import Flutter
import UIKit

public class FlanPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flan", binaryMessenger: registrar.messenger())
    let instance = FlanPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    switch call.method {
      case "scheduleNotificationAsync":
        await scheduleNotificationAsync(
          id: args["id"],
          content: args["content"],
          schedule: args["schedule"],
          result)
      case "cancelNotificationAsync":
        await cancelNotificationAsync(id: args["id"], result)
      case "getScheduledNotificationsAsync":
        await getScheduledNotificationsAsync(result)
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func scheduleNotificationAsync(
    id: String,
    content: [String: Any],
    schedule: [String: Any],
    result: @escaping FlutterResult
  ) async {
    let notification = UNMutableNotificationContent()
    notification.title = content["title"] as! String
    notification.body = content["body"] as! String

    let dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    dateComponents.timeZone = TimeZone.current
    dateComponents.year = schedule["year"] as? Int
    dateComponents.month = schedule["month"] as? Int
    dateComponents.day = schedule["day"] as? Int
    dateComponents.hour = schedule["hour"] as? Int
    dateComponents.minute = schedule["minute"] as? Int
    dateComponents.second = schedule["second"] as? Int
    dateComponents.weekOfMonth = schedule["weekOfMonth"] as? Int
    dateComponents.weekOfYear = schedule["weekOfYear"] as? Int
    dateComponents.weekday = schedule["weekday"] as? Int

    let trigger = UNCalendarNotificationTrigger(
      dateMatching: dateComponents,
      repeats: schedule["repeats"] as! Bool)

    let request = UNNotificationRequest(
      identifier: id,
      content: notification,
      trigger: trigger)

    let notificationCenter = UNUserNotificationCenter.current()
    do {
      try await notificationCenter.add(request)
      result(true)
    } catch error {
      result(FlutterError(code: "UNNotificationError", message: error.localizedDescription, details: nil))
    }
  }

  private func cancelNotificationAsync(id: String, result: @escaping FlutterResult) async {
    let notificationCenter = UNUserNotificationCenter.current()
    await notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    result(true)
  }

  private func getScheduledNotificationsAsync(result: @escaping FlutterResult) async {
    let center = UNUserNotificationCenter.current()
    let requests = await center.pendingNotificationRequests()
    let identifiers = requests.map { $0.identifier }
    result(identifiers)
  }
}

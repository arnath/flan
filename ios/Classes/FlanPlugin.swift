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
        args["id"] as! String,
        args["content"] as! [String: Any],
        args["schedule"] as! [String: Any],
        result)
    case "cancelNotificationAsync":
      await cancelNotificationAsync(args["id"] as! String, result)
    case "getScheduledNotificationsAsync":
      await getScheduledNotificationsAsync(result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func scheduleNotificationAsync(
    _ id: String,
    _ content: [String: Any],
    _ schedule: [String: Any],
    _ result: @escaping FlutterResult
  ) async {
    var notification = UNMutableNotificationContent()
    notification.title = content["title"] as! String
    notification.body = content["body"] as! String

    var dateComponents = DateComponents()
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
      result(nil)
    } catch error {
      result(
        FlutterError(code: "UNNotificationError", message: error.localizedDescription, details: nil)
      )
    }
  }

  private func cancelNotificationAsync(_ id: String, _ result: @escaping FlutterResult) async {
    let notificationCenter = UNUserNotificationCenter.current()
    await notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    result(nil)
  }

  private func getScheduledNotificationsAsync(_ result: @escaping FlutterResult) async {
    let center = UNUserNotificationCenter.current()
    let requests = await center.pendingNotificationRequests()
    let identifiers = requests.map { $0.identifier }
    result(identifiers)
  }
}

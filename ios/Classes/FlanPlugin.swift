import Flutter
import UIKit

public class FlanPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flan", binaryMessenger: registrar.messenger())
    let instance = FlanPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "scheduleNotificationAsync":
      Task {
        await scheduleNotificationAsync(call, result)
      }
    case "cancelNotificationAsync":
      Task {
        cancelNotificationAsync(call, result)
      }
    case "getScheduledNotificationsAsync":
      Task {
        await getScheduledNotificationsAsync(call, result)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func scheduleNotificationAsync(
    _ call: FlutterMethodCall, _ result: @escaping FlutterResult
  ) async {
    guard let args = call.arguments as? [String: Any] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Arguments are required and must be a valid dictionary.",
          details: nil))
      return
    }

    guard let id = args["id"] as? String else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'id' is missing or invalid.",
          details: nil))
      return
    }

    guard let content = args["content"] as? [String: Any] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'content' is missing or invalid.",
          details: nil))
      return
    }

    guard let schedule = args["schedule"] as? [String: Any] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'schedule' is missing or invalid.",
          details: nil))
      return
    }

    let notification = UNMutableNotificationContent()
    notification.title = content["title"] as? String ?? ""
    notification.body = content["body"] as? String ?? ""

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

    let repeats = schedule["repeats"] as? Bool ?? false

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)

    let request = UNNotificationRequest(
      identifier: id,
      content: notification,
      trigger: trigger
    )

    let notificationCenter = UNUserNotificationCenter.current()
    do {
      try await notificationCenter.add(request)
      result(nil)
    } catch {
      result(
        FlutterError(code: "UNNotificationError", message: error.localizedDescription, details: nil)
      )
    }
  }

  private func cancelNotificationAsync(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
  {
    guard let args = call.arguments as? [String: Any] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Arguments are required and must be a valid dictionary.",
          details: nil))
      return
    }

    guard let id = args["id"] as? String else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'id' is missing or invalid.",
          details: nil))
      return
    }

    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    result(nil)
  }

  private func getScheduledNotificationsAsync(
    _ call: FlutterMethodCall, _ result: @escaping FlutterResult
  ) async {
    let center = UNUserNotificationCenter.current()
    let requests = await center.pendingNotificationRequests()
    let identifiers = requests.map { $0.identifier }
    result(identifiers)
  }
}

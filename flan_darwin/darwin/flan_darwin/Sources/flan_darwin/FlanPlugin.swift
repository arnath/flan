import Flutter
import UIKit
import UserNotifications

public final class FlanPlugin: NSObject, FlutterPlugin, FlanApi {
  private let dateFormatter = ISO8601DateFormatter()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let plugin = FlanPlugin()
    FlanApiSetup.setUp(binaryMessenger: registrar.messenger(), api: plugin)
    registrar.publish(plugin)
  }

  func getNotificationSettingsAsync(completion: @escaping (Result<[String: String], Error>) -> Void)
  {
    let notificationCenter = UNUserNotificationCenter.current()
    let settings = await notificationCenter.notificationSettings()
    completion(.success(Converter.notificationSettingsToMap(settings)))
  }

  func requestAuthorizationAsync(
    options: [String], completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let options: UNAuthorizationOptions = options.reduce([]) { partialOptions, option in
      switch option {
      case "badge":
        return partialOptions.union(.badge)
      case "sound":
        return partialOptions.union(.sound)
      case "alert":
        return partialOptions.union(.alert)
      case "criticalAlert":
        return partialOptions.union(.criticalAlert)
      case "providesAppNotificationSettings":
        return partialOptions.union(.providesAppNotificationSettings)
      case "provisional":
        return partialOptions.union(.provisional)
      default:
        completion(
          .error(
            PigeonError(
              code: "InvalidArguments",
              message: "Invalid option '\(option)' provided in argument 'options'.",
              details: nil)))
        return partialOptions  // Ignore invalid options
      }
    }

    let notificationCenter = UNUserNotificationCenter.current()
    do {
      try await notificationCenter.requestAuthorization(options: options)
      completion(.success)
    } catch {
      completion(
        .error(
          FlutterError(
            code: "UNNotificationError",
            message: error.localizedDescription,
            details: nil)))
    }
  }

  func scheduleNotificationAsync(
    id: String, targetTimestamp: String, content: [String: Any?], repeats: Bool,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let notification = UNMutableNotificationContent()
    notification.title = content["title"] as? String ?? ""
    notification.subtitle = content["subtitle"] as? String ?? ""
    notification.body = content["body"] as? String ?? ""

    guard let targetDate = dateFormatter.date(from: targetTimestamp) else {
      completion(
        .error(
          PigeonError(
            code: "InvalidArguments",
            message:
              "Invalid date string '\(targetTimestamp)' provided in argument 'targetTimestamp'.",
            details: nil)))
      return
    }

    let dateComponents = Calendar.current.dateComponents(
      [.year, .month, .day, .hour, .minute, .second], from: targetDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)

    let request = UNNotificationRequest(
      identifier: id,
      content: notification,
      trigger: trigger
    )

    let notificationCenter = UNUserNotificationCenter.current()
    do {
      try await notificationCenter.add(request)
      completion(.success)
    } catch {
      completion(
        .error(
          (PigeonError(
            code: "UNNotificationError",
            message: error.localizedDescription,
            details: nil))))
    }
  }

  func cancelNotifications(ids: [String]) throws {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
  }

  func getScheduledNotificationsAsync(
    completion: @escaping (Result<[[String: Any?]], Error>) -> Void
  ) {
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationRequests = await notificationCenter.pendingNotificationRequests()
    let output = notificationRequests.map { Converter.notificationRequestToMap($0) }

    completion(.success(output))
  }
}

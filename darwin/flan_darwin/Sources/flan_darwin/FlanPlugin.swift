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

  /// Retrieves the current notification settings as a map of key-value pairs.
  func getNotificationSettingsAsync(
    completion: @escaping (Result<[String: dynamic], Error>) -> Void
  ) {
    let notificationCenter = UNUserNotificationCenter.current()
    let settings = await notificationCenter.notificationSettings()
    completion(.success(Converter.notificationSettingsToMap(settings)))
  }

  /// Requests notification authorization from the user with specified options.
  ///
  /// [options] specifies the types of notifications the application wants to send.
  /// Each option is an instance of [NotificationAuthorizationOptions]. Options must
  /// not be specified more than once.
  func requestAuthorizationAsync(
    options: [NotificationAuthorizationOptions], completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let options: UNAuthorizationOptions = options.reduce([]) { partialOptions, option in
      switch option {
      case .badge:
        return partialOptions.union(.badge)
      case .sound:
        return partialOptions.union(.sound)
      case .alert:
        return partialOptions.union(.alert)
      case .criticalAlert:
        return partialOptions.union(.criticalAlert)
      case .providesAppNotificationSettings:
        return partialOptions.union(.providesAppNotificationSettings)
      case .provisional:
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

  /// Schedules a notification to be delivered at a specified [target] time.
  ///
  /// [id] is a unique identifier for the notification.
  /// [targetTimestamp] specifies the delivery time for the notification as an ISO8601 date string.
  /// [content] contains the details of the notification, such as title and body.
  /// [repeats] indicates whether the notification should repeat. Defaults to `false`.
  func scheduleNotificationAsync(
    id: String, targetTimestamp: String, content: NotificationContent, repeats: Bool,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let notification = UNMutableNotificationContent()
    notification.title = content.title
    notification.body = content.body

    guard let targetDate = dateFormatter.date(from: targetTimestamp) else {
      completion(
        .error(
          PigeonError(
            code: "InvalidArguments",
            message: "Invalid date string '\(targetTimestamp)' provided in argument 'targetTimestamp'.",
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
      completion(.error((
        PigeonError(
          code: "UNNotificationError",
          message: error.localizedDescription,
          details: nil))))
    }
  }

  /// Cancels notifications with the specified [ids].
  ///
  /// [ids] is a list containing the unique identifiers of the notifications
  /// to be canceled.
  func cancelNotifications(ids: [String]) throws {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
  }

  /// Retrieves a list of all scheduled notifications.
  ///
  /// Returns a list of maps, where each map represents the details of a
  /// scheduled notification.
  func getScheduledNotificationsAsync(
    completion: @escaping (Result<[[String: dynamic]], Error>) -> Void
  ) {
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationRequests = await notificationCenter.pendingNotificationRequests()
    let output = notificationRequests.map { Converter.notificationRequestToMap($0) }

    completion(.success(output))
  }
}

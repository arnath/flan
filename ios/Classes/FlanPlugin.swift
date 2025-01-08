import Flutter
import UIKit
import UserNotifications

public class FlanPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flan", binaryMessenger: registrar.messenger())
    let instance = FlanPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    NSLog("FLAN: Received method call: \(call.method)")
    switch call.method {
    case "getNotificationSettingsAsync":
      Task {
        await getNotificationSettingsAsync(call, result)
      }
    case "requestAuthorizationAsync":
      Task {
        await requestAuthorizationAsync(call, result)
      }
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

  private func getNotificationSettingsAsync(
    _ call: FlutterMethodCall, _ result: @escaping FlutterResult
  ) async {
    let notificationCenter = UNUserNotificationCenter.current()
    let settings = await notificationCenter.notificationSettings()

    var output: [String: Any] = [
      "authorizationStatus": authorizationStatusToString(settings.authorizationStatus),
      "notificationCenterSetting": notificationSettingToString(settings.notificationCenterSetting),
      "lockScreenSetting": notificationSettingToString(settings.lockScreenSetting),
      "carPlaySetting": notificationSettingToString(settings.carPlaySetting),
      "alertSetting": notificationSettingToString(settings.alertSetting),
      "badgeSetting": notificationSettingToString(settings.badgeSetting),
      "soundSetting": notificationSettingToString(settings.soundSetting),
      "criticalAlertSetting": notificationSettingToString(settings.criticalAlertSetting),
      "announcementSetting": notificationSettingToString(settings.announcementSetting),
      "scheduledDeliverySetting": notificationSettingToString(settings.scheduledDeliverySetting),
      "timeSensitiveSetting": notificationSettingToString(settings.timeSensitiveSetting),
      "alertStyle": alertStyleToString(settings.alertStyle),
      "showPreviewsSetting": previewSettingToString(settings.showPreviewsSetting),
      "providesAppNotificationSettings": settings.providesAppNotificationSettings,
      "directMessagesSetting": notificationSettingToString(settings.directMessagesSetting),
    ]

    result(output)
  }

  private func requestAuthorizationAsync(
    _ call: FlutterMethodCall, _ result: @escaping FlutterResult
  )
    async
  {
    guard let args = call.arguments as? [String: Any] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Arguments are required and must be a valid dictionary.",
          details: nil))
      return
    }

    guard let optionsAsStrings = args["options"] as? [String] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'options' is missing or invalid.",
          details: nil))
      return
    }

    let options: UNAuthorizationOptions = optionsAsStrings.reduce([]) { partialOptions, option in
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
        result(
          FlutterError(
            code: "InvalidArguments",
            message: "Invalid option '\(option)' provided in argument 'options'.",
            details: nil))
        return partialOptions  // Ignore invalid options
      }
    }

    let notificationCenter = UNUserNotificationCenter.current()
    do {
      try await notificationCenter.requestAuthorization(options: options)
      result(nil)
    } catch {
      result(
        FlutterError(
          code: "UNNotificationError",
          message: error.localizedDescription,
          details: nil))
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

    guard let targetEpochSeconds = args["targetEpochSeconds"] as? Double else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'targetEpochSeconds' is missing or invalid.",
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

    guard let repeats = args["repeats"] as? Bool else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'repeats' is missing or invalid.",
          details: nil))
      return
    }

    let notification = UNMutableNotificationContent()
    notification.title = content["title"] as? String ?? ""
    notification.body = content["body"] as? String ?? ""

    let targetDate = Date(timeIntervalSince1970: targetEpochSeconds)
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
      result(nil)
    } catch {
      result(
        FlutterError(
          code: "UNNotificationError",
          message: error.localizedDescription,
          details: nil))
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
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationRequests = await notificationCenter.pendingNotificationRequests()

    let output: [[String: Any]] = notificationRequests.map { request -> [String: Any] in
      var requestMap: [String: Any] = [
        "id": request.identifier,
        "content": [
          "title": request.content.title,
          "subtitle": request.content.subtitle,
          "body": request.content.body,
        ],
      ]

      guard let schedule = request.trigger as? UNCalendarNotificationTrigger else {
        // App has somehow scheduled a request that doesn't have a calendar trigger.
        // This shouldn't happen.
        return requestMap
      }

      requestMap["schedule"] = [
        "year": schedule.dateComponents.year,
        "month": schedule.dateComponents.month,
        "day": schedule.dateComponents.day,
        "hour": schedule.dateComponents.hour,
        "minute": schedule.dateComponents.minute,
        "second": schedule.dateComponents.second,
        "weekOfMonth": schedule.dateComponents.weekOfMonth,
        "weekOfYear": schedule.dateComponents.weekOfYear,
        "weekday": schedule.dateComponents.weekday,
        "repeats": schedule.repeats,
      ]

      return requestMap
    }

    result(output)
  }

  private func previewSettingToString(_ previewSetting: UNShowPreviewsSetting) -> String {
    switch previewSetting {
    case .always:
      return "always"
    case .whenAuthenticated:
      return "whenAuthenticated"
    case .never:
      return "never"
    }
  }

  private func alertStyleToString(_ alertStyle: UNAlertStyle) -> String {
    switch alertStyle {
    case .none:
      return "none"
    case .banner:
      return "banner"
    case .alert:
      return "alert"
    }
  }

  private func authorizationStatusToString(_ status: UNAuthorizationStatus) -> String {
    switch status {
    case .notDetermined:
      return "notDetermined"
    case .denied:
      return "denied"
    case .authorized:
      return "authorized"
    case .provisional:
      return "provisional"
    case .ephemeral:
      return "ephemeral"
    }
  }

  private func notificationSettingToString(_ setting: UNNotificationSetting) -> String {
    switch setting {
    case .enabled:
      return "enabled"
    case .disabled:
      return "disabled"
    case .notSupported:
      return "notSupported"
    }
  }
}

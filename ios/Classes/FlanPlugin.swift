import Flutter
import UIKit
import UserNotifications

public class FlanPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flan", binaryMessenger: registrar.messenger(),
      codec: FlutterJSONMethodCodec.sharedInstance())
    let instance = FlanPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    NSLog("FLAN: Received method call: \(call.method)")
    switch call.method {
    case "requestAuthorizationAsync":
      Task {
        await requestAuthorizationAsync(call, result)
      }
    case "scheduleNotificationAsync":
      Task {
        await scheduleNotificationAsync(call, result)
      }
    case "cancelNotificationsAsync":
      Task {
        cancelNotificationsAsync(call, result)
      }
    case "getNotificationSettingsAsync":
      Task {
        await getNotificationSettingsAsync(call, result)
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
    let output = Converter.notificationSettingsToMap(settings)

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

  private func cancelNotificationsAsync(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
  {
    guard let args = call.arguments as? [String: Any] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Arguments are required and must be a valid dictionary.",
          details: nil))
      return
    }

    guard let ids = args["ids"] as? [String] else {
      result(
        FlutterError(
          code: "InvalidArguments",
          message: "Required argument 'ids' is missing or invalid.",
          details: nil))
      return
    }

    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    result(nil)
  }

  private func getScheduledNotificationsAsync(
    _ call: FlutterMethodCall, _ result: @escaping FlutterResult
  ) async {
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationRequests = await notificationCenter.pendingNotificationRequests()
    let output = notificationRequests.map { Converter.notificationRequestToMap($0) }

    result(output)
  }

}

public class Converter {
  public static func notificationRequestToMap(_ request: UNNotificationRequest) -> [String: Any] {
    var output = [
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
      return output
    }

    guard let targetEpochSeconds = Calendar.current.date(from: schedule.dateComponents) else {
      return output
    }

    output["targetEpochSeconds"] = targetEpochSeconds.timeIntervalSince1970
    output["repeats"] = schedule.repeats

    return output
  }

  public static func notificationSettingsToMap(_ settings: UNNotificationSettings) -> [String: Any]
  {
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
  }

  private static func previewSettingToString(_ previewSetting: UNShowPreviewsSetting) -> String {
    switch previewSetting {
    case .always:
      return "always"
    case .whenAuthenticated:
      return "whenAuthenticated"
    case .never:
      return "never"
    @unknown default:
      return "unknown"
    }
  }

  private static func alertStyleToString(_ alertStyle: UNAlertStyle) -> String {
    switch alertStyle {
    case .none:
      return "none"
    case .banner:
      return "banner"
    case .alert:
      return "alert"
    @unknown default:
      return "unknown"
    }
  }

  private static func authorizationStatusToString(_ status: UNAuthorizationStatus) -> String {
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
    @unknown default:
      return "unknown"
    }
  }

  private static func notificationSettingToString(_ setting: UNNotificationSetting) -> String {
    switch setting {
    case .enabled:
      return "enabled"
    case .disabled:
      return "disabled"
    case .notSupported:
      return "notSupported"
    @unknown default:
      return "unknown"
    }
  }
}

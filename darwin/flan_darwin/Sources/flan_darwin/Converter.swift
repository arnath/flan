import UserNotifications

public class Converter {
  public static func notificationRequestToMap(_ request: UNNotificationRequest) -> [String: Any] {
    var output: [String: Any] = [
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
    let output: [String: Any] = [
      "authorizationStatus": authorizationStatusToString(settings.authorizationStatus),
      "notificationCenterSetting": notificationSettingToString(settings.notificationCenterSetting),
      "lockScreenSetting": notificationSettingToString(settings.lockScreenSetting),
      "alertSetting": notificationSettingToString(settings.alertSetting),
      "badgeSetting": notificationSettingToString(settings.badgeSetting),
      "soundSetting": notificationSettingToString(settings.soundSetting),
      "criticalAlertSetting": notificationSettingToString(settings.criticalAlertSetting),
      "scheduledDeliverySetting": notificationSettingToString(settings.scheduledDeliverySetting),
      "timeSensitiveSetting": notificationSettingToString(settings.timeSensitiveSetting),
      "alertStyle": alertStyleToString(settings.alertStyle),
      "showPreviewsSetting": previewSettingToString(settings.showPreviewsSetting),
      "providesAppNotificationSettings": settings.providesAppNotificationSettings,
      "directMessagesSetting": notificationSettingToString(settings.directMessagesSetting),
    ]

    return output
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

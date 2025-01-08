# flan

Flan is a local notifications plugin for Flutter. It allows sending system
notifications.

![A sample toast from Flan](https://github.com/arnath/flan/blob/main/sample_toast.png)

Flan is currently very much in alpha and is something I wrote to support another
project. As such, it only supports iOS and only allows scheduling notifications
with a calendar trigger.

The example app mostly works. It will let you request permissions and add a
notification. Note that iOS does not deliver toasts when your app is in the
foreground.

The minimum supported iOS version is 15.0.

## Installation

```shell
flutter pub add flan
```

## Usage

Flan exposes the interface below:

```dart
import 'package:flan/models/notification_authorization_options.dart';
import 'package:flan/models/notification_content.dart';

abstract interface class Flan {
  /// Retrieves the current notification settings as a map of key-value pairs.
  ///
  /// Returns a [Future] containing a map with the current notification settings.
  Future<Map<String, dynamic>> getNotificationSettingsAsync();

  /// Requests notification authorization from the user with specified options.
  ///
  /// [options] specifies the types of notifications the application wants to send.
  /// Each option is an instance of [NotificationAuthorizationOptions]. Options must
  /// not be specified more than once.
  ///
  /// Returns a [Future] that completes when the request process finishes.
  Future<void> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  );

  /// Schedules a notification to be delivered at a specified [target] time.
  ///
  /// [id] is a unique identifier for the notification.
  /// [target] specifies the delivery time for the notification.
  /// [content] contains the details of the notification, such as title and body.
  /// [repeats] indicates whether the notification should repeat. Defaults to `false`.
  ///
  /// Returns a [Future] that completes when the notification is successfully
  /// scheduled.
  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
  });

  /// Cancels notifications with the specified [ids].
  ///
  /// [ids] is an iterable containing the unique identifiers of the notifications
  /// to be canceled.
  ///
  /// Returns a [Future] that completes when the notifications are successfully
  /// canceled.
  Future<void> cancelNotificationsAsync(Iterable<String> ids);

  /// Retrieves a list of all scheduled notifications.
  ///
  /// Returns a [Future] containing a list of maps, where each map represents
  /// the details of a scheduled notification.
  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync();
}
```

To use it, create an instance of the `FlanMethodChannel` class. The token is
just an arbitrary object:

```dart
Object token = Object();
Flan flan = FlanMethodChannel(token: token);
```

## Internals

For iOS, Flan uses the `UNUserNotificationCenter` APIs as described in [this
guide][apn] from Apple.

[apn]:
  https://developer.apple.com/documentation/usernotifications/scheduling-a-notification-locally-from-your-app

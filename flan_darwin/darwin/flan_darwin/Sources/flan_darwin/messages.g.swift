// Autogenerated from Pigeon (v22.7.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class PigeonError: Error {
  let code: String
  let message: String?
  let details: Any?

  init(code: String, message: String?, details: Any?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "PigeonError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? PigeonError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

private class MessagesPigeonCodecReader: FlutterStandardReader {
}

private class MessagesPigeonCodecWriter: FlutterStandardWriter {
}

private class MessagesPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return MessagesPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return MessagesPigeonCodecWriter(data: data)
  }
}

class MessagesPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = MessagesPigeonCodec(readerWriter: MessagesPigeonCodecReaderWriter())
}


/// The purpose of this Pigeon-defined API is basically to ensure type safety
/// of the primitive types when going between Dart and Swift and to provide
/// a slightly cleaner interface. As such, this is similar to but not the same
/// as the FlanApi. It replaces a lot of types with primitives supported by the
/// standard method codec.
///
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol FlanDarwinApi {
  func getNotificationSettings(completion: @escaping (Result<[String: String], Error>) -> Void)
  func requestAuthorization(options: [String], completion: @escaping (Result<Void, Error>) -> Void)
  func scheduleNotification(id: String, targetTimestamp: String, content: [String: Any?], repeats: Bool, completion: @escaping (Result<Void, Error>) -> Void)
  func cancelNotifications(ids: [String]) throws
  func getScheduledNotifications(completion: @escaping (Result<[[String: Any?]], Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class FlanDarwinApiSetup {
  static var codec: FlutterStandardMessageCodec { MessagesPigeonCodec.shared }
  /// Sets up an instance of `FlanDarwinApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: FlanDarwinApi?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let getNotificationSettingsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flan_darwin.FlanDarwinApi.getNotificationSettings\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getNotificationSettingsChannel.setMessageHandler { _, reply in
        api.getNotificationSettings { result in
          switch result {
          case .success(let res):
            reply(wrapResult(res))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      getNotificationSettingsChannel.setMessageHandler(nil)
    }
    let requestAuthorizationChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flan_darwin.FlanDarwinApi.requestAuthorization\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      requestAuthorizationChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let optionsArg = args[0] as! [String]
        api.requestAuthorization(options: optionsArg) { result in
          switch result {
          case .success:
            reply(wrapResult(nil))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      requestAuthorizationChannel.setMessageHandler(nil)
    }
    let scheduleNotificationChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flan_darwin.FlanDarwinApi.scheduleNotification\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      scheduleNotificationChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let idArg = args[0] as! String
        let targetTimestampArg = args[1] as! String
        let contentArg = args[2] as! [String: Any?]
        let repeatsArg = args[3] as! Bool
        api.scheduleNotification(id: idArg, targetTimestamp: targetTimestampArg, content: contentArg, repeats: repeatsArg) { result in
          switch result {
          case .success:
            reply(wrapResult(nil))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      scheduleNotificationChannel.setMessageHandler(nil)
    }
    let cancelNotificationsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flan_darwin.FlanDarwinApi.cancelNotifications\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      cancelNotificationsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let idsArg = args[0] as! [String]
        do {
          try api.cancelNotifications(ids: idsArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      cancelNotificationsChannel.setMessageHandler(nil)
    }
    let getScheduledNotificationsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flan_darwin.FlanDarwinApi.getScheduledNotifications\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getScheduledNotificationsChannel.setMessageHandler { _, reply in
        api.getScheduledNotifications { result in
          switch result {
          case .success(let res):
            reply(wrapResult(res))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      getScheduledNotificationsChannel.setMessageHandler(nil)
    }
  }
}

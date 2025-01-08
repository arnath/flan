import 'dart:convert';

import 'package:flutter/services.dart';

class FlanMethodCodec implements MethodCodec {
  const FlanMethodCodec();

  static final StringCodec _stringCodec = StringCodec();

  @override
  ByteData encodeMethodCall(MethodCall methodCall) {
    return _encodeMap(
      {
        'method': methodCall.method,
        'arguments': methodCall.arguments,
      },
    );
  }

  @override
  MethodCall decodeMethodCall(ByteData? methodCall) {
    Map<String, dynamic> payload = _decodeMap(methodCall);

    return MethodCall(payload['method'], payload['arguments']);
  }

  @override
  dynamic decodeEnvelope(ByteData envelope) {
    Map<String, dynamic> payload = _decodeMap(envelope);
    if (payload.isEmpty) {
      throw StateError('Envelope is empty');
    }

    if (payload.containsKey('result')) {
      return payload['result'];
    }

    throw PlatformException(
      code: payload['code'],
      message: payload['message'],
      details: payload['details'],
    );
  }

  @override
  ByteData encodeErrorEnvelope({
    required String code,
    String? message,
    Object? details,
  }) {
    return _encodeMap(
      {
        'code': code,
        'message': message,
        'details': details?.toString(),
      },
    );
  }

  @override
  ByteData encodeSuccessEnvelope(Object? result) {
    return _encodeMap({'result': result});
  }

  ByteData _encodeMap(Map<String, dynamic> map) {
    String json = jsonEncode(map);
    return _stringCodec.encodeMessage(json)!;
  }

  Map<String, dynamic> _decodeMap(ByteData? envelope) {
    if (envelope == null) {
      return {};
    }

    String json = _stringCodec.decodeMessage(envelope)!;
    return jsonDecode(json);
  }
}

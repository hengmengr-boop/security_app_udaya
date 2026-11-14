import 'package:equatable/equatable.dart';

/// Request body for `POST /auth/login`
final class AuthLoginRequest extends Equatable {
  const AuthLoginRequest({
    required this.username,
    required this.password,
    this.deviceId = '320794035e5bfcaf',
    this.deviceName = 'SM-S928B',
  });

  final String username;
  final String password;
  final String deviceId;
  final String deviceName;

  @override
  List<Object?> get props => [username, password, deviceId, deviceName];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'deviceId': deviceId,
        'deviceName': deviceName,
      };
}

/// Response body for `POST /auth/login`
final class AuthLoginResponse extends Equatable {
  const AuthLoginResponse({
    required this.status,
    required this.loginVerifyToken,
    this.userId,
    this.countLogin,
  });

  final bool status;
  final String loginVerifyToken;
  final int? userId;
  final int? countLogin;

  @override
  List<Object?> get props => [status, loginVerifyToken, userId, countLogin];

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    final body = json['body'] as Map<String, dynamic>? ?? json;
    final header = json['header'] as Map<String, dynamic>?;
    final token = (body['message'] ?? body['loginVerifyToken'] ?? '').toString();
    final isSuccess = (body['status'] as bool?) ?? (header?['result'] as bool?) ?? token.isNotEmpty;
    return AuthLoginResponse(
      status: isSuccess,
      loginVerifyToken: token,
      userId: (body['id'] ?? body['userId']) as int?,
      countLogin: body['countLogin'] as int?,
    );
  }
}

/// Request body for `POST /auth/validate/google-authenticator`
final class AuthValidate2FaRequest extends Equatable {
  const AuthValidate2FaRequest({
    required this.code,
    required this.username,
    required this.loginVerifyToken,
  });

  final String code;
  final String username;
  final String loginVerifyToken;

  @override
  List<Object?> get props => [code, username, loginVerifyToken];

  Map<String, dynamic> toJson() => {
        'code': code,
        'username': username,
        'loginVerifyToken': loginVerifyToken,
      };
}

/// Token data returned in `body` or `body.data[0]`
final class AuthTokenData extends Equatable {
  const AuthTokenData({
    required this.loginVerifyToken,
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
    this.expiresIn = 86399,
    this.scope,
  });

  final String loginVerifyToken;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final String? scope;

  @override
  List<Object?> get props => [
        loginVerifyToken,
        accessToken,
        refreshToken,
        tokenType,
        expiresIn,
        scope,
      ];

  factory AuthTokenData.fromJson(Map<String, dynamic> json) {
    return AuthTokenData(
      loginVerifyToken: (json['loginVerifyToken'] ?? '').toString(),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
      tokenType: (json['tokenType'] ?? 'bearer').toString(),
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 86399,
      scope: json['scope'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'loginVerifyToken': loginVerifyToken,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'tokenType': tokenType,
        'expiresIn': expiresIn,
        if (scope != null) 'scope': scope,
      };
}

/// Response body for `POST /auth/validate/google-authenticator`
final class AuthValidate2FaResponse extends Equatable {
  const AuthValidate2FaResponse({
    required this.status,
    required this.message,
    this.tokenData,
  });

  final bool status;
  final String message;
  final AuthTokenData? tokenData;

  @override
  List<Object?> get props => [status, message, tokenData];

  factory AuthValidate2FaResponse.fromJson(Map<String, dynamic> json) {
    final body = json['body'] as Map<String, dynamic>? ?? json;
    final header = json['header'] as Map<String, dynamic>?;
    final rawData = body['data'];
    AuthTokenData? token;

    if (rawData is List && rawData.isNotEmpty && rawData.first is Map) {
      token = AuthTokenData.fromJson(Map<String, dynamic>.from(rawData.first));
    } else if (rawData is Map) {
      token = AuthTokenData.fromJson(Map<String, dynamic>.from(rawData));
    } else if (body.containsKey('accessToken')) {
      token = AuthTokenData.fromJson(body);
    }

    final hasToken = token != null && token.accessToken.isNotEmpty;
    final isSuccess = (body['status'] as bool?) ?? (header?['result'] as bool?) ?? hasToken;

    return AuthValidate2FaResponse(
      status: isSuccess,
      message: (body['message'] ?? (hasToken ? 'Success' : '')).toString(),
      tokenData: token,
    );
  }
}

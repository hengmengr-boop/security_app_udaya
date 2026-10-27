import 'package:flutter/foundation.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

part 'ai_api_service.g.dart';

@RestApi(baseUrl: '')
abstract class AiApiService {
  factory AiApiService({required AIUse aiUse, Map<String, dynamic>? headers}) {
    // * Init Dio
    final dio = Dio();
    // * Dio Logger Interceptors
    if (kDebugMode) {
      dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseHeaders: false,
            printResponseData: true,
            printResponseMessage: true,
            printResponseTime: true,
          ),
        ),
      );
    }
    // * Dio Option
    dio.options = BaseOptions(
      headers: headers ??
          {
            if (aiUse == AIUse.claude) 'anthropic-version': C.claudeApiVersion,
            'Accept': 'application/json',
            'content-type': 'application/json',
          },
    );
    final baseUrl = aiUse == AIUse.gemini ? C.geminiApiBaseUrl : C.claudeApiBaseUrl;
    return _AiApiService(dio, baseUrl: baseUrl);
  }

  /// =======================================================================================================================
  /// AI Provider Endpoints
  /// =======================================================================================================================

  @POST('/models/{model}:generateContent')
  Future<dynamic> requestChatGemini({
    @Path('model') required String model,
    @Query('key') required String apiKey,
    @Body() required Map<String, dynamic> body,
  });

  @POST('/messages')
  Future<dynamic> requestChatClaude({
    @Header('x-api-key') required String apiKey,
    @Body() required Map<String, dynamic>  body,}
  );

}

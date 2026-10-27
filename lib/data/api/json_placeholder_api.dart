import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:udaya_visitor/data/models/post_model.dart';

part 'json_placeholder_api.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholderApi {
  factory JsonPlaceholderApi({Dio? dio}) {
    final clientDio = dio ?? Dio();
    clientDio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseData: true,
          printResponseMessage: true,
        ),
      ),
    );
    return _JsonPlaceholderApi(clientDio);
  }

  /// Get list of 100 posts
  @GET('/posts')
  Future<List<PostModel>> getPosts();

  /// Get single post by ID
  @GET('/posts/{id}')
  Future<PostModel> getPostById(@Path('id') int id);

  /// Create a new post
  @POST('/posts')
  Future<PostModel> createPost(@Body() PostModel post);
}

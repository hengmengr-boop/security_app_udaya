import 'package:flutter_test/flutter_test.dart';
import 'package:udaya_visitor/data/api/json_placeholder_api.dart';
import 'package:udaya_visitor/data/models/post_model.dart';

void main() {
  late JsonPlaceholderApi api;

  setUp(() {
    api = JsonPlaceholderApi();
  });

  group('JSONPlaceholder API Live Integration Tests', () {
    test('GET /posts - fetches list of 100 posts', () async {
      final posts = await api.getPosts();

      expect(posts, isNotEmpty);
      expect(posts.length, equals(100));
      expect(posts.first.id, equals(1));
      print('First post title: ${posts.first.title}');
    });

    test('GET /posts/1 - fetches single post by ID', () async {
      final post = await api.getPostById(1);

      expect(post.id, equals(1));
      expect(post.userId, equals(1));
      expect(post.title, isNotEmpty);
      print('Post 1 title: ${post.title}');
    });

    test('POST /posts - creates a new post', () async {
      const newPost = PostModel(
        userId: 1,
        id: 0,
        title: 'Internship Test Title',
        body: 'Testing JSONPlaceholder API with Retrofit and Dio',
      );

      final created = await api.createPost(newPost);

      expect(created.title, equals('Internship Test Title'));
      expect(created.id, isNotNull);
      print('Created post ID: ${created.id}');
    });
  });
}

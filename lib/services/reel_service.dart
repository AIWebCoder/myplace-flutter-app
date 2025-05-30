import 'package:dio/dio.dart';
import 'package:x_place/model/post_model.dart';
import 'package:x_place/services/dio.dart';

class PostService {
  static Future<List<Post>> fetchPosts(token, {required String postType}) async {
    try {
      final response = await DioClient.dio.get(
        '/get-all-post',
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        final filteredPosts = data.where((post) => post['post_type']?.toString() == postType).toList();
        return filteredPosts.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }
}


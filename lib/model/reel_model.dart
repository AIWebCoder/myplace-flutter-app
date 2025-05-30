// models/reel.dart
class Reel {
  final String videoUrl;
  final String thumbnail;
  final String username;
  final String userHandle;
  final String profileImage;
  final String caption;
  final int likes;
  final bool isVerified;

  Reel({
    required this.videoUrl,
    required this.thumbnail,
    required this.username,
    required this.userHandle,
    required this.profileImage,
    required this.caption,
    required this.likes,
    required this.isVerified,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    final attachment = json['attachments'] != null && json['attachments'].isNotEmpty ? json['attachments'][0] : null;

    return Reel(
      videoUrl: attachment != null ? '${attachment['path']}' : '',
      thumbnail: attachment != null ? '${attachment['thumbnail']}' : '',
      username: json['user']['name'] ?? '',
      userHandle: json['user']['username'] ?? '',
      profileImage: json['user']['avatar'] ?? '',
      caption: json['text'] ?? '',
      likes: json['tips_count'] ?? 0,
      isVerified: json['user']['identity_verified_at'] != null,
    );
  }
}

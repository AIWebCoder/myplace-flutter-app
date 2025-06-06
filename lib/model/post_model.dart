import 'attachment_model.dart';

class Post {
  final int? id;
  final int? userId;
  final String text;
  final double price;
  final int status;
  final String releaseDate;
  final String? expireDate;
  final int isPinned;
  final String createdAt;
  final String updatedAt;
  final String postType;
  final String? thumbnail;
  final String caption;
  final String? path;
  final List<dynamic> comments;
  final List<dynamic> reactions;
  final List<dynamic> bookmarks;
  final List<Attachment> attachments;


  // From your model
  final String videoUrl;
  final String username;
  final String userHandle;
  final String profileImage;
  final int likes;
  final bool isVerified;

  Post({
    this.id,
    this.userId,
    required this.text,
    required this.price,
    required this.status,
    required this.videoUrl,
    required this.releaseDate,
    this.expireDate,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.postType,
    this.thumbnail,
    this.path,
    required this.caption,
    required this.comments,
    required this.reactions,
    required this.bookmarks,
    required this.attachments,
    required this.username,
    required this.userHandle,
    required this.profileImage,
    required this.likes,
    required this.isVerified,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final attachmentsJson = json['attachments'] as List<dynamic>? ?? [];
    final firstAttachment = attachmentsJson.isNotEmpty ? attachmentsJson.first : null;
    final attachment = json['attachments'] != null && json['attachments'].isNotEmpty ? json['attachments'][0] : null;

    return Post(
      videoUrl: attachment != null ? '${attachment['path']}' : '',
      thumbnail: attachment != null ? '${attachment['thumbnail']}' : '',
      caption: json['text'] ?? '',
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      text: json['text'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      expireDate: json['expire_date'],
      isPinned: json['is_pinned'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      postType: json['post_type'] ?? '',
      path: json['path'] ?? (firstAttachment?['path']),
      comments: json['comments'] ?? [],
      reactions: json['reactions'] ?? [],
      bookmarks: json['bookmarks'] ?? [],
      attachments: attachmentsJson
          .map((att) => Attachment.fromJson(att as Map<String, dynamic>))
          .toList(),
      username: user['name'] ?? '',
      userHandle: user['username'] ?? '',
      profileImage: user['avatar'] ?? '',
      likes: json['tips_count'] ?? 0,
      isVerified: user['identity_verified_at'] != null,
    );
  }

  // Utility getters
  String get displayText => text.isEmpty ? 'Contenu sans description' : text;
  String get displayType => postType.isEmpty ? 'Post' : postType;
  bool get hasVideoAttachments => attachments.any((att) => att.isVideo);
  bool get hasImageAttachments => attachments.any((att) => att.isImage);
  bool get isPaidContent => price > 0;
  bool get isFeatured => isPinned == 1;

  List<Attachment> get videoAttachments =>
      attachments.where((att) => att.isVideo).toList();
  List<Attachment> get imageAttachments =>
      attachments.where((att) => att.isImage).toList();

  String? get primaryThumbnail =>
      thumbnail?.isNotEmpty == true
          ? thumbnail
          : videoAttachments.isNotEmpty
              ? videoAttachments.first.thumbnail
              : imageAttachments.isNotEmpty
                  ? imageAttachments.first.thumbnail
                  : null;

  String? get primaryPath =>
      path?.isNotEmpty == true
          ? path
          : attachments.isNotEmpty
              ? attachments.first.path
              : null;

  String get contentSummary =>
      text.length > 100 ? '${text.substring(0, 100)}...' : text;

  bool get hasMediaContent =>
      (thumbnail?.isNotEmpty ?? false) ||
      (path?.isNotEmpty ?? false) ||
      attachments.isNotEmpty;

  String get primaryMediaType {
    if (hasVideoAttachments || (path?.contains('.mp4') ?? false)) {
      return 'video';
    } else if (hasImageAttachments || (thumbnail?.isNotEmpty ?? false)) {
      return 'image';
    }
    return 'text';
  }
}

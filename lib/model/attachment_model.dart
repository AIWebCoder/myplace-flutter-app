class Attachment {
  final String id;
  final String filename;
  final int driver;
  final String type;
  final int userId;
  final int postId;
  final String? messageId;
  final String? coconutId;
  final bool? hasThumbnail;
  final bool? hasBlurredPreview;
  final String createdAt;
  final String updatedAt;
  final String? paymentRequestId;
  final String attachmentType;
  final String path;
  final String thumbnail;

  Attachment({
    required this.id,
    required this.filename,
    required this.driver,
    required this.type,
    required this.userId,
    required this.postId,
    this.messageId,
    this.coconutId,
    this.hasThumbnail,
    this.hasBlurredPreview,
    required this.createdAt,
    required this.updatedAt,
    this.paymentRequestId,
    required this.attachmentType,
    required this.path,
    required this.thumbnail,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id']?.toString() ?? '',
      filename: json['filename'] as String? ?? '',
      driver: json['driver'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      userId: json['user_id'] as int? ?? 0,
      postId: json['post_id'] as int? ?? 0,
      messageId: json['message_id'] as String?,
      coconutId: json['coconut_id'] as String?,
      hasThumbnail: json['has_thumbnail'] as bool?,
      hasBlurredPreview: json['has_blurred_preview'] as bool?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      paymentRequestId: json['payment_request_id'] as String?,
      attachmentType: json['attachmentType'] as String? ?? json['attachment_type'] as String? ?? '',
      path: json['path'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'driver': driver,
      'type': type,
      'user_id': userId,
      'post_id': postId,
      'message_id': messageId,
      'coconut_id': coconutId,
      'has_thumbnail': hasThumbnail,
      'has_blurred_preview': hasBlurredPreview,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'payment_request_id': paymentRequestId,
      'attachmentType': attachmentType,
      'path': path,
      'thumbnail': thumbnail,
    };
  }

  // Méthodes utilitaires
  bool get isVideo => type.toLowerCase().contains('video') || 
                     attachmentType.toLowerCase().contains('video') ||
                     filename.toLowerCase().endsWith('.mp4') ||
                     filename.toLowerCase().endsWith('.mov') ||
                     filename.toLowerCase().endsWith('.avi');

  bool get isImage => type.toLowerCase().contains('image') || 
                     attachmentType.toLowerCase().contains('image') ||
                     filename.toLowerCase().endsWith('.jpg') ||
                     filename.toLowerCase().endsWith('.jpeg') ||
                     filename.toLowerCase().endsWith('.png') ||
                     filename.toLowerCase().endsWith('.gif');

  String get displayName => filename.isEmpty ? 'Fichier sans nom' : filename;

  String get fileExtension {
    final parts = filename.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }
}

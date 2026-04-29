class Post {
  final String id;
  final String thumbUrl;
  final String fullUrl;
  final String rawUrl;

  int likeCount;
  bool isLiked;

  Post({
    required this.id,
    required this.thumbUrl,
    required this.fullUrl,
    required this.rawUrl,
    this.likeCount = 0,
    this.isLiked = false,
  });

  factory Post.fromMap(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),

      thumbUrl: json['media_thumb_url'] ?? '',
      fullUrl: json['media_mobile_url'] ?? '',
      rawUrl: json['media_raw_url'] ?? '',

      likeCount: json['like_count'] ?? 0,

      /// ✅ IMPORTANT FIX
      isLiked: json['is_liked'] ?? false,
    );
  }

  /// 🔥 OPTIONAL (pro-level: immutability support)
  Post copyWith({
    String? id,
    String? thumbUrl,
    String? fullUrl,
    String? rawUrl,
    int? likeCount,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      fullUrl: fullUrl ?? this.fullUrl,
      rawUrl: rawUrl ?? this.rawUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
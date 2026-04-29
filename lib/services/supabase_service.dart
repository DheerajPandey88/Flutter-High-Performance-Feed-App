class SupabaseService {
  static const userId = "user_123";

  /// Fake DB cache (simulate backend state)
  final Map<String, bool> _likedMap = {};

  /// FETCH POSTS (mock API)
  Future<List<Map<String, dynamic>>> fetchPosts(int page) async {
    await Future.delayed(const Duration(milliseconds: 700));

    /// Simulate occasional network error (real-world feel)
    if (page > 0 && page % 5 == 0) {
      throw Exception("Network error");
    }

    return List.generate(10, (index) {
      final id = page * 10 + index;
      final isLiked = _likedMap["$id"] ?? false;

      return {
        "id": "$id",

        /// Thumbnail (fast load)
        "media_thumb_url":
            "https://picsum.photos/id/${id % 100}/300/300",

        /// Full screen
        "media_mobile_url":
            "https://picsum.photos/id/${id % 100}/1080/1080",

        /// Download high-res
        "media_raw_url":
            "https://picsum.photos/id/${id % 100}/2000/2000",

        /// Randomized like count
        "like_count": (id * 7) % 120,

        /// Track like state
        "is_liked": isLiked,
      };
    });
  }

  /// TOGGLE LIKE (simulate backend)
  Future<void> toggleLike(String postId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    /// Simulate failure (rare)
    if (DateTime.now().millisecondsSinceEpoch % 20 == 0) {
      throw Exception("Like failed");
    }

    /// Toggle local state (fake DB)
    final current = _likedMap[postId] ?? false;
    _likedMap[postId] = !current;
  }
}
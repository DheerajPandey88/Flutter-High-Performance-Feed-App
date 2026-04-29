import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../services/supabase_service.dart';
import '../main.dart';

final postProvider =
    StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>((ref) {
  return PostNotifier();
});

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  PostNotifier() : super(const AsyncLoading());

  final _service = SupabaseService();

  int page = 0;
  bool isLoading = false;
  bool hasMore = true;

  final Map<String, Timer> _debounce = {};

  /// FETCH POSTS
  Future<void> fetchPosts({bool refresh = false}) async {
    if (isLoading || !hasMore) return;
    isLoading = true;

    final previous = state.value ?? [];

    try {
      if (refresh) {
        page = 0;
        hasMore = true;

        /// Keep old data while refreshing (better UX)
        state = const AsyncLoading();
      }

      final data = await _service.fetchPosts(page);
      final posts = data.map<Post>((e) => Post.fromMap(e)).toList();

      if (posts.isEmpty) {
        hasMore = false;
      }

      /// IMAGE PRELOAD (safe)
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        Future.microtask(() {
          for (final post in posts) {
            precacheImage(NetworkImage(post.thumbUrl), ctx);
          }
        });
      }

      final updated = refresh ? posts : [...previous, ...posts];

      state = AsyncData(updated);

      page++;
    } catch (e, st) {
      /// KEEP OLD DATA ON ERROR (important)
      if (previous.isNotEmpty) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(e, st);
      }
    }

    isLoading = false;
  }

  /// LIKE TOGGLE
  Future<void> toggleLike(Post post) async {
    final old = post.isLiked;

    /// Optimistic UI
    post.isLiked = !post.isLiked;
    post.likeCount += post.isLiked ? 1 : -1;

    final current = state.value ?? [];
    state = AsyncData([...current]);

    /// Debounce
    _debounce[post.id]?.cancel();

    _debounce[post.id] =
        Timer(const Duration(milliseconds: 500), () async {
      try {
        await _service.toggleLike(post.id, SupabaseService.userId);
      } catch (_) {
        /// Revert
        post.isLiked = old;
        post.likeCount += old ? 1 : -1;

        final current = state.value ?? [];
        state = AsyncData([...current]);
      }
    });
  }

  /// CLEANUP
  @override
  void dispose() {
    for (final timer in _debounce.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
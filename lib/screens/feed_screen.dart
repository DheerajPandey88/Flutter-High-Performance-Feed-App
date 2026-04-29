import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import 'package:shimmer/shimmer.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(postProvider.notifier).fetchPosts();
    });

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final notifier = ref.read(postProvider.notifier);
    final state = ref.read(postProvider);

    final posts = state.value ?? [];

    if (_controller.page != null &&
        _controller.page! >= posts.length - 2) {
      notifier.fetchPosts();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postProvider);
    final notifier = ref.read(postProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,

      /// ❌ Removed AppBar → immersive UI
      body: state.when(
        loading: () => _buildShimmer(),

        error: (e, _) => _buildError(),

        data: (posts) {
          if (posts.isEmpty) {
            return _buildEmpty();
          }

          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.black,
            onRefresh: () => notifier.fetchPosts(refresh: true),

            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,

              /// 🔥 Reel-like snapping
              physics: const PageScrollPhysics(),

              itemCount: posts.length +
                  (notifier.hasMore ? 1 : 0),

              itemBuilder: (_, i) {
                /// LOADER ONLY IF MORE DATA EXISTS
                if (i >= posts.length) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                return PostCard(post: posts[i]);
              },
            ),
          );
        },
      ),
    );
  }

  /// 🔥 PREMIUM ERROR UI
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 40),
          const SizedBox(height: 10),
          const Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              ref.read(postProvider.notifier).fetchPosts(refresh: true);
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  /// 🟡 EMPTY STATE
  Widget _buildEmpty() {
    return const Center(
      child: Text(
        "No posts available",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  /// ✨ BETTER SHIMMER
  Widget _buildShimmer() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 3,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade700,
        child: Container(
          color: Colors.black,
        ),
      ),
    );
  }
}
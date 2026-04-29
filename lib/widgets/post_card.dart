import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../providers/download_provider.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool showHeart = false;

  void _like() {
    HapticFeedback.lightImpact();

    setState(() => showHeart = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => showHeart = false);
    });

    ref.read(postProvider.notifier).toggleLike(widget.post);
  }

  void _download() {
    ref.read(downloadProvider.notifier).startDownload(widget.post.rawUrl);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Download started")),
    );
  }

  void _openMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PremiumMenu(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return RepaintBoundary(
      child: GestureDetector(
        onDoubleTap: _like,
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// 🖼 IMAGE
            CachedNetworkImage(
              imageUrl: post.fullUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              placeholder: (_, __) =>
                  Container(color: Colors.black),
            ),

            /// ❤️ HEART ANIMATION
            AnimatedOpacity(
              opacity: showHeart ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Center(
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            ),

            /// 🔝 TOP BAR
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(post.thumbUrl),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "photographer",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  /// 🔥 FIXED MENU BUTTON
                  IconButton(
                    icon: const Icon(Icons.more_vert,
                        color: Colors.white),
                    onPressed: _openMenu,
                  ),
                ],
              ),
            ),

            /// 🌑 GRADIENT
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// 🔻 BOTTOM ACTIONS
            Positioned(
              bottom: 40,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          post.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: post.isLiked
                              ? Colors.red
                              : Colors.white,
                        ),
                        onPressed: _like,
                      ),
                      Text(
                        "${post.likeCount}",
                        style: const TextStyle(
                            color: Colors.white),
                      ),
                    ],
                  ),

                  IconButton(
                    icon: const Icon(Icons.download,
                        color: Colors.white),
                    onPressed: _download,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔥 PREMIUM MENU (GLASS STYLE)
class _PremiumMenu extends ConsumerWidget {
  final Post post;
  const _PremiumMenu({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(
            context,
            icon: Icons.share,
            label: "Share",
            onTap: () {
              Navigator.pop(context);
              Share.share(post.rawUrl);
            },
          ),
          _item(
            context,
            icon: Icons.download,
            label: "Download",
            onTap: () {
              Navigator.pop(context);
              ref
                  .read(downloadProvider.notifier)
                  .startDownload(post.rawUrl);
            },
          ),
          _item(
            context,
            icon: Icons.link,
            label: "Copy Link",
            onTap: () {
              Navigator.pop(context);
              Clipboard.setData(
                  ClipboardData(text: post.rawUrl));
            },
          ),
          _item(
            context,
            icon: Icons.report,
            label: "Report",
            color: Colors.red,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context,
      {required IconData icon,
      required String label,
      Color color = Colors.white,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
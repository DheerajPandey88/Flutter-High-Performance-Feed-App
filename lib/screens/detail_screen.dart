import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../providers/download_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final Post post;
  const DetailScreen({super.key, required this.post});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => loaded = true);
    });
  }

  void _download() {
    ref
        .read(downloadProvider.notifier)
        .startDownload(widget.post.rawUrl);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Download started...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// IMAGE WITH HERO
          Center(
            child: Hero(
              tag: post.id,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// LOW RES (fast load)
                  CachedNetworkImage(
                    imageUrl: post.thumbUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),

                  /// HIGH RES FADE IN
                  AnimatedOpacity(
                    opacity: loaded ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: CachedNetworkImage(
                      imageUrl: post.fullUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// GRADIENT OVERLAY (bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
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

          /// DOWNLOAD BUTTON (GLASS STYLE)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.9),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _download,
              icon: const Icon(Icons.download),
              label: const Text("Download High Quality"),
            ),
          ),
        ],
      ),
    );
  }
}
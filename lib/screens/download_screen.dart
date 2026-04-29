import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/download_provider.dart';
import '../models/download_model.dart';

class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Downloads")),
      body: downloads.isEmpty
          ? const Center(child: Text("No downloads yet"))
          : ListView.builder(
              itemCount: downloads.length,
              itemBuilder: (_, i) {
                final item = downloads[i];

                return ListTile(
                  title: Text(item.url.split('/').last),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(value: item.progress),
                      const SizedBox(height: 4),
                      Text("${(item.progress * 100).toInt()}%"),
                    ],
                  ),
                  trailing: _buildTrailing(ref, item),
                );
              },
            ),
    );
  }

  Widget _buildTrailing(WidgetRef ref, DownloadItem item) {
    switch (item.status) {
      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () =>
              ref.read(downloadProvider.notifier).cancelDownload(item.id),
        );

      case DownloadStatus.completed:
        return const Icon(Icons.check, color: Colors.green);

      case DownloadStatus.failed:
        return const Icon(Icons.error, color: Colors.red);

      case DownloadStatus.canceled:
        return const Icon(Icons.close, color: Colors.grey);
    }
  }
}
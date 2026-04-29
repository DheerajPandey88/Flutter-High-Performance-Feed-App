import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/download_model.dart';
final downloadProvider =
    StateNotifierProvider<DownloadNotifier, List<DownloadItem>>((ref) {
  return DownloadNotifier();
});

class DownloadNotifier extends StateNotifier<List<DownloadItem>> {
  DownloadNotifier() : super([]);

  final Dio _dio = Dio();
  final Map<String, CancelToken> _tokens = {};

  Future<void> startDownload(String url) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final item = DownloadItem(id: id, url: url);
    state = [...state, item];

    final token = CancelToken();
    _tokens[id] = token;

    try {
      /// ✅ App storage (no permission issues)
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/$id.jpg";

      await _dio.download(
        url,
        path,
        cancelToken: token,
        onReceiveProgress: (rec, total) {
          if (total <= 0) return;

          final progress = (rec / total).clamp(0.0, 1.0);
          _update(id, progress, DownloadStatus.downloading);
        },
      );

      _update(id, 1, DownloadStatus.completed);

      _tokens.remove(id);
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        _update(id, 0, DownloadStatus.canceled);
      } else {
        _update(id, 0, DownloadStatus.failed);
      }

      _tokens.remove(id);
    }
  }

  void cancelDownload(String id) {
    _tokens[id]?.cancel();
  }

  void _update(String id, double progress, DownloadStatus status) {
    state = [
      for (final item in state)
        if (item.id == id)
          DownloadItem(
            id: item.id,
            url: item.url,
            progress: progress,
            status: status,
          )
        else
          item
    ];
  }
}
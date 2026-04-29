enum DownloadStatus { downloading, completed, failed, canceled }

class DownloadItem {
  final String id;
  final String url;
  double progress;
  DownloadStatus status;

  DownloadItem({
    required this.id,
    required this.url,
    this.progress = 0,
    this.status = DownloadStatus.downloading,
  });
}
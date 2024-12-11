import 'package:flutter/material.dart';

class VideoDownloadTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDownloading;
  final double? progress;

  const VideoDownloadTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isDownloading = false,
    this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          if (isDownloading && progress != null)
            LinearProgressIndicator(value: progress),
        ],
      ),
      trailing: IconButton(
        icon: Icon(isDownloading ? Icons.stop : Icons.download),
        onPressed: onTap,
      ),
    );
  }
}

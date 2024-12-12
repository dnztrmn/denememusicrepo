import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundy/services/download_service.dart';
import 'package:soundy/widgets/video_card.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final DownloadService _downloadService = DownloadService();
  List<Map<String, dynamic>> _downloads = [];

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    final downloads = await _downloadService.getDownloads();
    setState(() {
      _downloads = downloads;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: _downloads.isEmpty
          ? const Center(
              child: Text('No downloads yet'),
            )
          : ListView.builder(
              itemCount: _downloads.length,
              itemBuilder: (context, index) {
                final download = _downloads[index];
                return VideoCard(
                  title: download['title'],
                  subtitle: download['artist'],
                  thumbnailUrl: download['thumbnailUrl'],
                  onTap: () {
                    // Handle download playback
                  },
                );
              },
            ),
    );
  }
}
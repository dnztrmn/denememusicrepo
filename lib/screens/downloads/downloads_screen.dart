import 'package:flutter/material.dart';
import '../../models/video.dart';
import '../../services/download_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/video_download_tile.dart';

class DownloadsScreen extends StatefulWidget {
  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final DownloadService _downloadService = DownloadService();
  final StorageService _storageService = StorageService();
  List<Video> _downloadedVideos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloadedVideos();
  }

  Future<void> _loadDownloadedVideos() async {
    setState(() => _isLoading = true);
    final videos = await _storageService.getOfflineVideos();
    setState(() {
      _downloadedVideos = videos;
      _isLoading = false;
    });
  }

  Future<void> _deleteVideo(Video video) async {
    await _storageService.deleteOfflineVideo(video.id);
    await _loadDownloadedVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
        actions: [
          IconButton(
            icon: Icon(Icons.storage),
            onPressed: () {
              // Show storage info dialog
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _downloadedVideos.isEmpty
              ? _buildEmptyState()
              : _buildDownloadsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_done,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No downloaded songs',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadsList() {
    return ListView.builder(
      itemCount: _downloadedVideos.length,
      itemBuilder: (context, index) {
        final video = _downloadedVideos[index];
        return VideoDownloadTile(
          video: video,
          onDelete: () => _deleteVideo(video),
        );
      },
    );
  }
}

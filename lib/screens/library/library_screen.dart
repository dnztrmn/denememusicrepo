import 'package:flutter/material.dart';
import '../../models/video.dart';
import '../../services/storage_service.dart';
import '../../widgets/video_download_tile.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Downloads'),
            Tab(text: 'Playlists'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDownloadsTab(),
          _buildPlaylistsTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildDownloadsTab() {
    return FutureBuilder<List<Video>>(
      future: _storageService.getOfflineVideos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No downloaded videos'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return VideoDownloadTile(
              video: snapshot.data![index],
              onDelete: () async {
                await _storageService.deleteOfflineVideo(
                  snapshot.data![index].id,
                );
                setState(() {});
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return Center(
      child: Text('Playlists coming soon'),
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Text('History coming soon'),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
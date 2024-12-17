import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundy/screens/player/player_screen.dart';
import 'package:soundy/services/download_service.dart';
import 'package:soundy/widgets/video_card.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<Map<String, dynamic>> _downloads = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    try {
      final downloads = await DownloadService().getDownloads();
      if (mounted) {
        setState(() {
          _downloads = downloads;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading downloads: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _downloads.isEmpty
              ? const Center(child: Text('No downloads yet'))
              : ListView.builder(
                  itemCount: _downloads.length,
                  itemBuilder: (context, index) {
                    final download = _downloads[index];
                    return VideoCard(
                      title: download['title'],
                      subtitle: download['artist'],
                      thumbnailUrl: download['thumbnailUrl'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              videoId: download['id'],
                              title: download['title'],
                              author: download['artist'],
                              thumbnailUrl: download['thumbnailUrl'],
                              localFilePath: download['filePath'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

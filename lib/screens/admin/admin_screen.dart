import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:soundy/services/youtube_service.dart';
import 'package:soundy/utils/error_handler.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key); // const kaldırıldı

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _playlistController = TextEditingController();
  final Box appBox = Hive.box('appBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Playlist Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _playlistController,
              decoration: const InputDecoration(
                labelText: 'Playlist URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _addPlaylist(context),
              child: const Text('Add Playlist'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: appBox.listenable(),
                builder: (context, box, child) {
                  final playlists =
                      box.get('playlists', defaultValue: []) as List;
                  return ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(playlists[index].toString()),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removePlaylist(context, index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPlaylist(BuildContext context) async {
    try {
      final youtubeService =
          Provider.of<YoutubeService>(context, listen: false);
      await youtubeService.addPlaylist(_playlistController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playlist added successfully')),
      );
      _playlistController.clear();
    } catch (e) {
      if (!mounted) return;
      handleError(context, e);
    }
  }

  Future<void> _removePlaylist(BuildContext context, int index) async {
    try {
      final youtubeService =
          Provider.of<YoutubeService>(context, listen: false);
      await youtubeService.removePlaylist(index);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playlist removed successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      handleError(context, e);
    }
  }

  @override
  void dispose() {
    _playlistController.dispose();
    super.dispose();
  }
}

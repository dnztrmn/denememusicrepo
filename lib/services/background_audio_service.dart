import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../models/video.dart';
import 'notification_manager.dart';

class BackgroundAudioService extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  final _notificationManager = NotificationManager();

  // Durum yayınları
  final BehaviorSubject<List<Video>> _queue = BehaviorSubject.seeded([]);
  final BehaviorSubject<Video?> _currentVideo = BehaviorSubject.seeded(null);

  BackgroundAudioService() {
    _init();
  }

  Future<void> _init() async {
    // Player olaylarını dinle
    _player.playbackEventStream.listen(_broadcastState);

    // Ses kaynağını ayarla
    await _player.setAudioSource(_playlist);

    // Bildirim yöneticisini başlat
    await _notificationManager.initialize();
  }

  // Video ekleme
  Future<void> addVideo(Video video) async {
    final audioSource = AudioSource.uri(
      Uri.parse(video.audioUrl),
      tag: MediaItem(
        id: video.id,
        title: video.title,
        artist: video.channelTitle,
        artUri: Uri.parse(video.thumbnail),
      ),
    );

    await _playlist.add(audioSource);
    final queue = _queue.value..add(video);
    _queue.add(queue);
  }

  // Oynatma kontrolleri
  @override
  Future<void> play() async {
    await _player.play();
    _updateNotification();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _updateNotification();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await _notificationManager.cancelNotification();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
    _updateNotification();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
    _updateNotification();
  }

  // Durum yayını
  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ),
    );
  }

  void _updateNotification() {
    if (_currentVideo.value != null) {
      _notificationManager.showMusicNotification(
        video: _currentVideo.value!,
        isPlaying: _player.playing,
        duration: _player.duration ?? Duration.zero,
        position: _player.position,
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
    await _queue.close();
    await _currentVideo.close();
    super.dispose();
  }
}

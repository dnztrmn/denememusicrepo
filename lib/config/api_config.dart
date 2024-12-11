class APIConfig {
  static const int MAX_API_KEYS = 50;
  static const String API_BOX_NAME = 'youtube_api_keys';
  static const String USER_BOX_NAME = 'user_data';
  static const int QUOTA_COST_SEARCH = 100;
  static const int QUOTA_COST_VIDEO = 1;
  static const int QUOTA_COST_PLAYLIST = 2;

  // YouTube API Anahtarı
  static const String YOUTUBE_API_KEY =
      'AIzaSyA5gL3cL4kITrjiQ1N7RKdNE3J_XsMFmE0'; // Google Cloud Console'dan aldığınız API anahtarını buraya yazın

  // YouTube API endpoint'leri
  static const String YOUTUBE_BASE_URL =
      'https://www.googleapis.com/youtube/v3';
  static const String YOUTUBE_SEARCH_URL = '$YOUTUBE_BASE_URL/search';
  static const String YOUTUBE_VIDEOS_URL = '$YOUTUBE_BASE_URL/videos';
  static const String YOUTUBE_PLAYLISTS_URL = '$YOUTUBE_BASE_URL/playlists';

  static const List<String> ADMIN_EMAILS = [
    // Admin e-postalarını buraya ekleyin
    'dnztrmn16@gmail.gmail.com',
  ];
}

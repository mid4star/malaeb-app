import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../models/channel_model.dart';
import '../models/movie_model.dart';
import '../core/services/api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  String _currentTab = "الرئيسية";
  String get currentTab => _currentTab;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LiveMatch> _liveMatches = [];
  List<LiveMatch> get liveMatches => _liveMatches;

  List<ScheduledMatch> _scheduledMatches = [];
  List<ScheduledMatch> get scheduledMatches => _scheduledMatches;

  List<ChannelCategory> _categories = [];
  List<ChannelCategory> get categories => _categories;

  String _selectedCategory = "all";
  String get selectedCategory => _selectedCategory;

  List<ChannelModel> _channels = [];
  List<ChannelModel> get channels => _channels;

  List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  final Set<int> _favorites = {};
  Set<int> get favorites => _favorites;

  final Set<int> _reminders = {};
  Set<int> get reminders => _reminders;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  // Active playing stream
  Map<String, dynamic>? _activePlayingStream;
  Map<String, dynamic>? get activePlayingStream => _activePlayingStream;

  // Multi-View Quad Player state
  bool _isMultiPlayerActive = false;
  bool get isMultiPlayerActive => _isMultiPlayerActive;

  final List<Map<String, dynamic>?> _multiSlots = [null, null, null, null];
  List<Map<String, dynamic>?> get multiSlots => _multiSlots;

  void openMultiPlayer({Map<String, dynamic>? initialStream}) {
    if (initialStream != null) {
      _multiSlots[0] = initialStream;
    }
    _isMultiPlayerActive = true;
    _activePlayingStream = null; // Close single player if open
    notifyListeners();
  }

  void closeMultiPlayer() {
    _isMultiPlayerActive = false;
    notifyListeners();
  }

  void setMultiSlot(int index, Map<String, dynamic> stream) {
    if (index >= 0 && index < 4) {
      _multiSlots[index] = stream;
      notifyListeners();
    }
  }

  void removeMultiSlot(int index) {
    if (index >= 0 && index < 4) {
      _multiSlots[index] = null;
      notifyListeners();
    }
  }

  AppProvider() {
    initData();
  }

  void setTab(String tab) {
    _currentTab = tab;
    notifyListeners();
  }

  void setSelectedCategory(String catId) {
    _selectedCategory = catId;
    notifyListeners();
  }

  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  void toggleReminder(int id) {
    if (_reminders.contains(id)) {
      _reminders.remove(id);
    } else {
      _reminders.add(id);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<String> get searchResults {
    if (_searchQuery.trim().isEmpty) return [];
    final q = _searchQuery.toLowerCase();
    final results = <String>[];
    
    for (var m in _liveMatches) {
      if (m.home.toLowerCase().contains(q) || m.away.toLowerCase().contains(q)) {
        results.add("${m.home} ضد ${m.away}");
      }
    }
    for (var c in _channels) {
      if (c.name.toLowerCase().contains(q)) {
        results.add(c.name);
      }
    }
    for (var m in _movies) {
      if (m.title.toLowerCase().contains(q)) {
        results.add(m.title);
      }
    }
    return results;
  }

  Future<void> playStream({
    required String title,
    String? url,
    String? userAgent,
    Map<String, String>? headers,
  }) async {
    _isLoading = true;
    notifyListeners();

    final resolved = await _apiService.resolveStream(
      url ?? "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      userAgent: userAgent,
    );

    _activePlayingStream = {
      "title": title,
      "url": resolved['url'],
      "agent": resolved['agent'],
      "headers": resolved['headers'],
    };

    _isLoading = false;
    notifyListeners();
  }

  void closePlayer() {
    _activePlayingStream = null;
    notifyListeners();
  }

  Future<bool> activateFgCode(String code) async {
    _isLoading = true;
    notifyListeners();

    final success = await _apiService.activateFgCode(code);
    await initData();

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> initData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _liveMatches = await _apiService.getLiveMatches();
      _scheduledMatches = await _apiService.getScheduledMatches();
      _categories = await _apiService.getChannelCategories();
      _channels = await _apiService.getChannelsByTopic("all");
      _movies = _apiService.getFallbackMovies();
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../crypto/drama_crypto.dart';
import '../../models/match_model.dart';
import '../../models/channel_model.dart';
import '../../models/movie_model.dart';

class ApiService {
  static const String defaultServerUrl = "http://main.eastgoessouth.online/api/live/livedrama/v13.0.0/";
  static const String defaultLiveUrl = "http://live.eastgoessouth.online/api/live/livedrama/v13.0.0/";
  static const String defaultSportUrl = "http://sport.eastgoessouth.online/sport/";
  static const String defaultRedirectUrl = "http://redirect.eastgoessouth.online/redirect/";

  String serverUrl = defaultServerUrl;
  String liveUrl = defaultLiveUrl;
  String sportUrl = defaultSportUrl;
  String redirectUrl = defaultRedirectUrl;

  Map<String, dynamic> _getBasePayload({String activatedType = 'FG'}) {
    return {
      "user_id": "malaeb_client_usr_01",
      "device_id": "malaeb_dev_id_01",
      "device_api": "34",
      "version_name": "13.0.3",
      "language": "ar",
      "timezone": "Africa/Cairo",
      "device_type": "phone",
      "KEY_ACTIVATED_TYPE": activatedType,
      "store": "google",
      "isStoreVersion": false,
      "isPremium": true,
      "isCoupon_active": true,
      "hideAds": true,
      "appCount": "1",
      "mainServer": serverUrl,
    };
  }

  Future<dynamic> _postEncrypted(String url, Map<String, dynamic> extraData) async {
    try {
      final payload = _getBasePayload();
      payload.addAll(extraData);

      final jsonStr = json.encode(payload);
      final encryptedBody = DramaCrypto.encrypt(jsonStr);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "User-Agent": "okhttp/4.12.0",
        },
        body: utf8.encode(encryptedBody),
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decrypted = DramaCrypto.decrypt(response.body);
        final decoded = json.decode(decrypted);
        return decoded;
      }
    } catch (e) {
      // Return null on network error
    }
    return null;
  }

  /// Activate FG Code
  Future<bool> activateFgCode(String code) async {
    final res = await _postEncrypted("${serverUrl}activate", {"code": code});
    if (res != null && res['result'] == 1) {
      return true;
    }
    return false;
  }

  /// Fetch Live Matches from Sport server
  Future<List<LiveMatch>> getLiveMatches() async {
    final res = await _postEncrypted("${sportUrl}getMatches", {});
    if (res != null && res['data'] is List) {
      return (res['data'] as List).map((m) => LiveMatch.fromJson(m)).toList();
    }
    return _getFallbackLiveMatches();
  }

  /// Fetch Scheduled Matches
  Future<List<ScheduledMatch>> getScheduledMatches() async {
    return _getFallbackSchedule();
  }

  /// Fetch Channel Categories (Topics)
  Future<List<ChannelCategory>> getChannelCategories() async {
    final res = await _postEncrypted("${liveUrl}getliveTopics", {"type": "tv"});
    if (res != null && res['data'] is List) {
      return (res['data'] as List).map((c) => ChannelCategory.fromJson(c)).toList();
    }
    return _getFallbackCategories();
  }

  /// Fetch Channels by Category (Topic)
  Future<List<ChannelModel>> getChannelsByTopic(String topicId) async {
    final res = await _postEncrypted("${liveUrl}getLiveByTopic", {
      "type": "tv",
      "topic": topicId,
    });
    if (res != null && res['data'] is List) {
      return (res['data'] as List).map((c) => ChannelModel.fromJson(c)).toList();
    }
    return _getFallbackChannels();
  }

  /// Resolve stream URL and required HTTP headers
  Future<Map<String, dynamic>> resolveStream(String streamUrl, {String? userAgent, String? id}) async {
    if (streamUrl.contains("redirect.eastgoessouth") || streamUrl.contains("mode=live")) {
      final res = await _postEncrypted("${redirectUrl}getLiveByRedirect", {
        "id": id ?? "0",
        "url": streamUrl,
        "agent": userAgent ?? "Mozilla/5.0",
      });
      if (res != null && res['data'] != null) {
        final data = res['data'];
        return {
          "url": data['url'] ?? streamUrl,
          "agent": data['agent'] ?? userAgent ?? "Mozilla/5.0 (Linux; Android 14)",
          "headers": Map<String, String>.from(data['headers'] ?? {}),
        };
      }
    }
    return {
      "url": streamUrl,
      "agent": userAgent ?? "Mozilla/5.0 (Linux; Android 14)",
      "headers": <String, String>{
        "Referer": "https://dramalive.app/",
        "Origin": "https://dramalive.app",
      },
    };
  }

  // --- Fallback data matching Figma Design ---
  List<LiveMatch> _getFallbackLiveMatches() {
    return const [
      LiveMatch(
        id: 1,
        league: "الدوري الإنجليزي",
        home: "مانشستر سيتي",
        away: "ليفربول",
        score: "2 - 1",
        minute: "67'",
        color1: "#72c8f3",
        color2: "#e94444",
        code1: "M",
        code2: "L",
        viewers: "128K",
        streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      ),
      LiveMatch(
        id: 2,
        league: "دوري أبطال أوروبا",
        home: "ريال مدريد",
        away: "بايرن ميونخ",
        score: "1 - 1",
        minute: "42'",
        color1: "#f7f7f7",
        color2: "#e63636",
        code1: "RM",
        code2: "B",
        viewers: "96K",
        streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      ),
      LiveMatch(
        id: 3,
        league: "الدوري السعودي",
        home: "الهلال",
        away: "النصر",
        score: "3 - 2",
        minute: "81'",
        color1: "#1478e9",
        color2: "#f2c936",
        code1: "H",
        code2: "N",
        viewers: "84K",
        streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      ),
      LiveMatch(
        id: 4,
        league: "الدوري الإسباني",
        home: "برشلونة",
        away: "إشبيلية",
        score: "2 - 0",
        minute: "55'",
        color1: "#a82e53",
        color2: "#efefef",
        code1: "B",
        code2: "S",
        viewers: "72K",
        streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      ),
      LiveMatch(
        id: 5,
        league: "الدوري الإيطالي",
        home: "ميلان",
        away: "روما",
        score: "0 - 0",
        minute: "31'",
        color1: "#b92f35",
        color2: "#e9a22c",
        code1: "M",
        code2: "R",
        viewers: "51K",
        streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      ),
      LiveMatch(
        id: 6,
        league: "الدوري الفرنسي",
        home: "باريس",
        away: "موناكو",
        score: "1 - 0",
        minute: "23'",
        color1: "#243e9a",
        color2: "#e84141",
        code1: "P",
        code2: "M",
        viewers: "43K",
        streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
      ),
    ];
  }

  List<ScheduledMatch> _getFallbackSchedule() {
    return const [
      ScheduledMatch(
        time: "08:00",
        period: "م",
        league: "الدوري الإسباني",
        home: "برشلونة",
        away: "أتلتيكو مدريد",
        hc: "B",
        ac: "A",
        hColor: "#b7314b",
        aColor: "#e44545",
        channel: "beIN Sports 1",
        status: "لم تبدأ",
      ),
      ScheduledMatch(
        time: "10:00",
        period: "م",
        league: "دوري أبطال أوروبا",
        home: "باريس",
        away: "إنتر ميلان",
        hc: "P",
        ac: "I",
        hColor: "#17316b",
        aColor: "#1d5ebd",
        channel: "beIN Sports Premium 1",
        status: "لم تبدأ",
      ),
      ScheduledMatch(
        time: "11:30",
        period: "م",
        league: "الدوري الإنجليزي",
        home: "أرسنال",
        away: "تشيلسي",
        hc: "AR",
        ac: "C",
        hColor: "#e63333",
        aColor: "#1c4fb8",
        channel: "beIN Sports 2",
        status: "لم تبدأ",
      ),
    ];
  }

  List<ChannelCategory> _getFallbackCategories() {
    return const [
      ChannelCategory(id: "all", name: "الكل"),
      ChannelCategory(id: "sports", name: "رياضية"),
      ChannelCategory(id: "news", name: "إخبارية"),
      ChannelCategory(id: "entertainment", name: "ترفيهية"),
      ChannelCategory(id: "kids", name: "أطفال"),
      ChannelCategory(id: "documentary", name: "وثائقية"),
    ];
  }

  List<ChannelModel> _getFallbackChannels() {
    return const [
      ChannelModel(id: "1", name: "beIN Sports 1", tag: "رياضة", color: "#372074", viewers: "45K", quality: "FHD", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
      ChannelModel(id: "2", name: "beIN Sports 2", tag: "رياضة", color: "#372074", viewers: "38K", quality: "FHD", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
      ChannelModel(id: "3", name: "SSC 1 HD", tag: "رياضة", color: "#14488b", viewers: "52K", quality: "4K", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
      ChannelModel(id: "4", name: "Abu Dhabi Sports", tag: "رياضة", color: "#006837", viewers: "22K", quality: "HD", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
      ChannelModel(id: "5", name: "MBC 1", tag: "عامة", color: "#e4002b", viewers: "29K", quality: "FHD", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
      ChannelModel(id: "6", name: "Al Jazeera", tag: "أخبار", color: "#b97b09", viewers: "33K", quality: "HD", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
      ChannelModel(id: "7", name: "National Geo", tag: "وثائقي", color: "#d9a100", viewers: "15K", quality: "FHD", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
      ChannelModel(id: "8", name: "Spacetoon", tag: "أطفال", color: "#0088cc", viewers: "19K", quality: "HD", streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
    ];
  }

  List<MovieModel> getFallbackMovies() {
    return const [
      MovieModel(
        id: "m1",
        title: "كوكب الأرض III",
        meta: "وثائقي • 2024",
        imageUrl: "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&auto=format&fit=crop&q=80",
        category: "وثائقي",
        rating: "9.2",
      ),
      MovieModel(
        id: "m2",
        title: "حكاية بطل: زيدان",
        meta: "رياضي • 2023",
        imageUrl: "https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=600&auto=format&fit=crop&q=80",
        category: "سيرة ذاتية",
        rating: "8.7",
      ),
      MovieModel(
        id: "m3",
        title: "نهائي القرن",
        meta: "كلاسيكيات • 2022",
        imageUrl: "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=600&auto=format&fit=crop&q=80",
        category: "مباريات تاريخية",
        rating: "9.6",
      ),
    ];
  }
}

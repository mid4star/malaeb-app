class LiveMatch {
  final int id;
  final String league;
  final String home;
  final String away;
  final String score;
  final String minute;
  final String color1;
  final String color2;
  final String code1;
  final String code2;
  final String viewers;
  final String? streamUrl;
  final String? userAgent;
  final Map<String, String>? headers;

  const LiveMatch({
    required this.id,
    required this.league,
    required this.home,
    required this.away,
    required this.score,
    required this.minute,
    required this.color1,
    required this.color2,
    required this.code1,
    required this.code2,
    required this.viewers,
    this.streamUrl,
    this.userAgent,
    this.headers,
  });

  factory LiveMatch.fromJson(Map<String, dynamic> json) {
    return LiveMatch(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      league: json['league'] ?? json['topic'] ?? '',
      home: json['firstTeam'] ?? json['home'] ?? '',
      away: json['secondtTeam'] ?? json['away'] ?? '',
      score: json['score'] ?? "${json['firstTeamScore'] ?? '0'} - ${json['secondtTeamScore'] ?? '0'}",
      minute: json['minute'] ?? 'مباشر',
      color1: json['color1'] ?? '#72c8f3',
      color2: json['color2'] ?? '#e94444',
      code1: json['code1'] ?? (json['home'] != null && json['home'].toString().isNotEmpty ? json['home'].toString().substring(0, 1) : 'H'),
      code2: json['code2'] ?? (json['away'] != null && json['away'].toString().isNotEmpty ? json['away'].toString().substring(0, 1) : 'A'),
      viewers: json['viewers'] ?? '50K',
      streamUrl: json['url'],
      userAgent: json['agent'],
    );
  }
}

class ScheduledMatch {
  final String time;
  final String period;
  final String league;
  final String home;
  final String away;
  final String hc;
  final String ac;
  final String hColor;
  final String aColor;
  final String channel;
  final String status;
  final String? streamUrl;

  const ScheduledMatch({
    required this.time,
    required this.period,
    required this.league,
    required this.home,
    required this.away,
    required this.hc,
    required this.ac,
    required this.hColor,
    required this.aColor,
    required this.channel,
    required this.status,
    this.streamUrl,
  });

  factory ScheduledMatch.fromJson(Map<String, dynamic> json) {
    return ScheduledMatch(
      time: json['time'] ?? '08:00',
      period: json['period'] ?? 'م',
      league: json['league'] ?? '',
      home: json['home'] ?? json['firstTeam'] ?? '',
      away: json['away'] ?? json['secondtTeam'] ?? '',
      hc: json['hc'] ?? 'H',
      ac: json['ac'] ?? 'A',
      hColor: json['hColor'] ?? '#b7314b',
      aColor: json['aColor'] ?? '#e44545',
      channel: json['channel'] ?? 'beIN Sports',
      status: json['status'] ?? 'لم تبدأ',
      streamUrl: json['url'],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/brand_widget.dart';
import '../widgets/section_title.dart';
import '../widgets/match_card.dart';
import '../widgets/schedule_row.dart';
import '../widgets/channel_card.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedDay = "اليوم";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- HERO SHOWCASE BANNER ---
          _buildHeroSection(context, provider),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 36),

                // --- SECTION: LIVE MATCHES ---
                SectionTitle(
                  title: "مباشر الآن",
                  sub: "المباريات المنقولة حالياً مع البث المباشر المتاح",
                  action: "عرض الكل (${provider.liveMatches.length})",
                  onAction: () => provider.setTab("مباشر"),
                ),
                const SizedBox(height: 18),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    final isTablet = constraints.maxWidth > 600;
                    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.liveMatches.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 215,
                      ),
                      itemBuilder: (context, index) {
                        final match = provider.liveMatches[index];
                        return MatchCardWidget(
                          match: match,
                          isFavorite: provider.favorites.contains(match.id),
                          onFavorite: () => provider.toggleFavorite(match.id),
                          onPlay: () => provider.playStream(
                            title: "${match.home} × ${match.away}",
                            url: match.streamUrl,
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 48),

                // --- SECTION: SCHEDULE ---
                SectionTitle(
                  title: "جدول المباريات",
                  sub: "مواعيد قمم اليوم وغداً مع القنوات الناقلة",
                  action: "الجدول الكامل",
                  onAction: () => provider.setTab("المباريات"),
                ),
                const SizedBox(height: 16),

                // Day Tabs (أمس, اليوم, غداً)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101116),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      _buildDayTab("أمس", "28 مايو"),
                      _buildDayTab("اليوم", "29 مايو"),
                      _buildDayTab("غداً", "30 مايو"),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Schedule List Box
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1015),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.scheduledMatches.take(3).length,
                    itemBuilder: (context, index) {
                      final match = provider.scheduledMatches[index];
                      return ScheduleRowWidget(
                        match: match,
                        isReminded: provider.reminders.contains(index),
                        onRemind: () => provider.toggleReminder(index),
                        onTap: () => provider.playStream(
                          title: "${match.home} × ${match.away}",
                          url: match.streamUrl,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 48),

                // --- SECTION: TOP CHANNELS ---
                SectionTitle(
                  title: "القنوات الأكثر مشاهدة",
                  sub: "باقات رياضية وترفيهية بجودات عالية FHD و 4K",
                  action: "كل القنوات",
                  onAction: () => provider.setTab("القنوات"),
                ),
                const SizedBox(height: 18),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    final isTablet = constraints.maxWidth > 600;
                    final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.channels.take(8).length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 78,
                      ),
                      itemBuilder: (context, index) {
                        final channel = provider.channels[index];
                        return ChannelCardWidget(
                          channel: channel,
                          onPlay: () => provider.playStream(
                            title: channel.name,
                            url: channel.streamUrl,
                            userAgent: channel.userAgent,
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 48),

                // --- SECTION: MOVIES & SERIES ---
                SectionTitle(
                  title: "أفلام ومسلسلات مختارة",
                  sub: "أحدث الأعمال السينمائية والوثائقية الرياضية",
                  action: "المكتبة الترفيهية",
                  onAction: () => provider.setTab("أفلام ومسلسلات"),
                ),
                const SizedBox(height: 18),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    final isTablet = constraints.maxWidth > 600;
                    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.movies.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 220,
                      ),
                      itemBuilder: (context, index) {
                        final movie = provider.movies[index];
                        return MovieCardWidget(
                          movie: movie,
                          onPlay: () => provider.playStream(
                            title: movie.title,
                            url: movie.streamUrl,
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AppProvider provider) {
    return Container(
      height: 420,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Stadium Image
          Image.network(
            "https://images.unsplash.com/photo-1629217855633-79a6925d6c47?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1800",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF14151B)),
          ),

          // Horizontal & Vertical Shading
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.heroShadeHorizontal,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.heroShadeVertical,
            ),
          ),

          // Hero Content
          Positioned(
            right: 24,
            left: 24,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const LivePill(text: "بث مباشر الآن"),
                const SizedBox(height: 14),
                const Text(
                  "القمة المنتظرة • دوري أبطال أوروبا",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textKicker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: const TextSpan(
                    text: 'باريس سان جيرمان ',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: '×',
                        style: TextStyle(color: AppColors.red),
                      ),
                      TextSpan(text: ' إنتر ميلان'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "شاهد نهائي دوري أبطال أوروبا مباشرةً بجودة فائقة FHD وبدون أي تقطيع",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFC1C3CA),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: const [
                    Icon(Icons.access_time_rounded, size: 16, color: AppColors.textMuted),
                    SizedBox(width: 5),
                    Text(
                      "اليوم، 10:00 مساءً",
                      style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                    SizedBox(width: 14),
                    Text("•", style: TextStyle(color: AppColors.textDim)),
                    SizedBox(width: 14),
                    Text(
                      "beIN Sports Premium 1",
                      style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                        shadowColor: AppColors.redGlow,
                      ),
                      onPressed: () => provider.playStream(
                        title: "باريس سان جيرمان × إنتر ميلان",
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: const Text(
                        "شاهد الآن",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0x33FFFFFF)),
                        backgroundColor: const Color(0x66191A1F),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => provider.setTab("المباريات"),
                      icon: const Icon(Icons.info_outline_rounded, size: 18),
                      label: const Text(
                        "تفاصيل المباراة",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTab(String title, String date) {
    final isSelected = _selectedDay == title;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDay = title;
          });
        },
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceActive : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white70 : AppColors.textDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

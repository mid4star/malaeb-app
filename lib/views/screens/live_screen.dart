import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/section_title.dart';
import '../widgets/match_card.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  String _selectedLeague = "الكل";

  final List<String> _leagues = [
    "الكل",
    "دوري أبطال أوروبا",
    "الدوري الإنجليزي",
    "الدوري الإسباني",
    "الدوري السعودي",
    "الدوري الإيطالي",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    final filteredMatches = _selectedLeague == "الكل"
        ? provider.liveMatches
        : provider.liveMatches.where((m) => m.league.contains(_selectedLeague)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle(
            title: "المباريات المباشرة",
            sub: "تابع مجريات المباريات الحالية وانتقل فوراً للبث بدون إعلانات",
            action: "",
          ),
          const SizedBox(height: 18),

          // League Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _leagues.map((league) {
                final isSelected = _selectedLeague == league;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(league),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedLeague = league);
                    },
                    selectedColor: AppColors.red,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? AppColors.red : AppColors.border,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Matches Grid
          if (filteredMatches.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              alignment: Alignment.center,
              child: const Text(
                "لا توجد مباريات جارية حالياً في هذه البطولة",
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;
                final isTablet = constraints.maxWidth > 600;
                final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMatches.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 215,
                  ),
                  itemBuilder: (context, index) {
                    final match = filteredMatches[index];
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
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/brand_widget.dart';
import '../modals/search_modal.dart';
import '../modals/settings_modal.dart';
import '../player/video_player_modal.dart';
import '../player/multi_player_modal.dart';
import 'home_screen.dart';
import 'live_screen.dart';
import 'channels_screen.dart';
import 'schedule_screen.dart';
import 'entertainment_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  bool _searchModalOpen = false;
  bool _settingsModalOpen = false;

  final List<Map<String, dynamic>> _tabs = [
    {"label": "الرئيسية", "icon": Icons.home_rounded},
    {"label": "مباشر", "icon": Icons.sensors_rounded},
    {"label": "القنوات", "icon": Icons.live_tv_rounded},
    {"label": "المباريات", "icon": Icons.calendar_today_rounded},
    {"label": "أفلام ومسلسلات", "icon": Icons.movie_filter_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildHeader(context, provider, isDesktop),
        body: Stack(
          children: [
            _buildActiveScreen(provider.currentTab),

            // Video Player Overlay Modal
            if (provider.activePlayingStream != null)
              VideoPlayerModal(
                title: provider.activePlayingStream!['title'] ?? 'بث مباشر',
                streamUrl: provider.activePlayingStream!['url'] ?? '',
                userAgent: provider.activePlayingStream!['agent'],
                headers: provider.activePlayingStream!['headers'],
                onClose: () => provider.closePlayer(),
              ),

            // Quad Multi-View Overlay Modal
            if (provider.isMultiPlayerActive)
              MultiPlayerModal(
                onClose: () => provider.closeMultiPlayer(),
              ),

            // Instant Search Modal
            if (_searchModalOpen)
              SearchModalWidget(
                query: provider.searchQuery,
                results: provider.searchResults,
                onQueryChanged: (val) => provider.setSearchQuery(val),
                onSelect: (item) {
                  setState(() => _searchModalOpen = false);
                  provider.playStream(title: item);
                },
                onClose: () => setState(() => _searchModalOpen = false),
              ),

            // Settings & FG Code Modal
            if (_settingsModalOpen)
              SettingsModalWidget(
                onClose: () => setState(() => _settingsModalOpen = false),
              ),
          ],
        ),
        bottomNavigationBar: !isDesktop ? _buildMobileNav(context, provider) : null,
      ),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context, AppProvider provider, bool isDesktop) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xEE08090C),
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              InkWell(
                onTap: () => provider.setTab("الرئيسية"),
                child: const BrandWidget(size: 23),
              ),

              // Desktop Navigation Links
              if (isDesktop)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _tabs.map((tab) {
                    final isSelected = provider.currentTab == tab['label'];
                    return InkWell(
                      onTap: () => provider.setTab(tab['label']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: isSelected
                              ? const Border(bottom: BorderSide(color: AppColors.red, width: 3))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              tab['icon'],
                              size: 18,
                              color: isSelected ? Colors.white : AppColors.textMuted,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              tab['label'],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

              // Header Actions (Multi-View, Search, Notification, Profile)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.grid_view_rounded, color: AppColors.textWhite, size: 21),
                    onPressed: () => provider.openMultiPlayer(),
                    tooltip: "بث متعدد (شاشات رباعية)",
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: AppColors.textWhite, size: 22),
                    onPressed: () => setState(() => _searchModalOpen = true),
                    tooltip: "بحث سريع",
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite, size: 22),
                        onPressed: () {},
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => setState(() => _settingsModalOpen = true),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFF24262E),
                            child: Icon(Icons.settings_rounded, size: 16, color: Colors.white),
                          ),
                          SizedBox(width: 7),
                          Text(
                            "الإعدادات / FG",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context, AppProvider provider) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xF208090C),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _tabs.map((tab) {
          final isSelected = provider.currentTab == tab['label'];
          final displayLabel = tab['label'] == "أفلام ومسلسلات" ? "ترفيه" : tab['label'];

          return InkWell(
            onTap: () => provider.setTab(tab['label']),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab['icon'],
                    size: 21,
                    color: isSelected ? AppColors.red : AppColors.textDim,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    displayLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textDim,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveScreen(String tab) {
    switch (tab) {
      case "مباشر":
        return const LiveScreen();
      case "القنوات":
        return const ChannelsScreen();
      case "المباريات":
        return const ScheduleScreen();
      case "أفلام ومسلسلات":
        return const EntertainmentScreen();
      case "الرئيسية":
      default:
        return const HomeScreen();
    }
  }
}

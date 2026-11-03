import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/section_title.dart';
import '../widgets/channel_card.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  String _channelFilter = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    final filteredChannels = provider.channels.where((c) {
      final matchesSearch = _channelFilter.isEmpty || c.name.toLowerCase().contains(_channelFilter.toLowerCase());
      final matchesCat = provider.selectedCategory == "all" || c.tag.contains(provider.selectedCategory);
      return matchesSearch && matchesCat;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle(
            title: "دليل القنوات التلفزيونية",
            sub: "تصفح القنوات المباشرة مصنفة بدقة عالية FHD و 4K",
            action: "",
          ),
          const SizedBox(height: 18),

          // Categories Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: provider.categories.map((cat) {
                final isSelected = provider.selectedCategory == cat.id;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) provider.setSelectedCategory(cat.id);
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
          const SizedBox(height: 18),

          // Search Field
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: "ابحث عن اسم القناة...",
                hintStyle: TextStyle(color: AppColors.textDim, fontSize: 13),
                icon: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                border: InputBorder.none,
              ),
              onChanged: (val) => setState(() => _channelFilter = val),
            ),
          ),
          const SizedBox(height: 24),

          // Channels Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 600;
              final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredChannels.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 78,
                ),
                itemBuilder: (context, index) {
                  final channel = filteredChannels[index];
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
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/section_title.dart';
import '../widgets/schedule_row.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedDay = "اليوم";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle(
            title: "جدول مواعيد المباريات",
            sub: "توقيت المباريات بالدقيقة مع القنوات والترددات والناقلين",
            action: "",
          ),
          const SizedBox(height: 18),

          // Day Selection Tabs
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
          const SizedBox(height: 18),

          // Matches List
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F1015),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.scheduledMatches.length,
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
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildDayTab(String title, String date) {
    final isSelected = _selectedDay == title;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedDay = title),
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceActive : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
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

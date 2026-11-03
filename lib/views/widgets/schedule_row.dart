import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/match_model.dart';
import 'brand_widget.dart';

class ScheduleRowWidget extends StatelessWidget {
  final ScheduledMatch match;
  final bool isReminded;
  final VoidCallback onRemind;
  final VoidCallback? onTap;

  const ScheduleRowWidget({
    super.key,
    required this.match,
    required this.isReminded,
    required this.onRemind,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            // Time & Period
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.time,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    match.period == 'م' ? 'مساءً' : 'صباحاً',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // League & Status
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.league,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA4A6AD),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    match.status,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF666872),
                    ),
                  ),
                ],
              ),
            ),

            // Teams (Home vs Away)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    match.home,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TeamBadgeWidget(
                    code: match.hc,
                    colorHex: match.hColor,
                    isSmall: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "ضد",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF5E606A),
                      ),
                    ),
                  ),
                  TeamBadgeWidget(
                    code: match.ac,
                    colorHex: match.aColor,
                    isSmall: true,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    match.away,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Channel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.tv_rounded,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    match.channel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF898B94),
                    ),
                  ),
                ],
              ),
            ),

            // Remind button
            InkWell(
              onTap: onRemind,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isReminded ? AppColors.surfaceActive : Colors.transparent,
                  border: Border.all(
                    color: isReminded ? AppColors.red : AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isReminded ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                      size: 16,
                      color: isReminded ? AppColors.red : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isReminded ? "تم التذكير" : "ذكّرني",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isReminded ? Colors.white : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

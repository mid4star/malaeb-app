import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/channel_model.dart';

class ChannelCardWidget extends StatelessWidget {
  final ChannelModel channel;
  final VoidCallback onPlay;

  const ChannelCardWidget({
    super.key,
    required this.channel,
    required this.onPlay,
  });

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll("#", "");
      if (clean.length == 6) {
        return Color(int.parse("0xFF$clean"));
      } else if (clean.length == 8) {
        return Color(int.parse("0x$clean"));
      }
    } catch (_) {}
    return const Color(0xFF372074);
  }

  @override
  Widget build(BuildContext context) {
    final logoBg = _parseColor(channel.color);

    return InkWell(
      onTap: onPlay,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Channel Logo Box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: logoBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: logoBg.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.live_tv_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Channel Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          channel.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          channel.quality,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6868),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${channel.tag} • ${channel.viewers} متابع",
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textDim,
                    ),
                  ),
                ],
              ),
            ),

            // Play Icon Button
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFF22242B),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFBFC1C7),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

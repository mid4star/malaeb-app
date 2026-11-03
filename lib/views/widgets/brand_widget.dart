import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BrandWidget extends StatelessWidget {
  final double size;
  const BrandWidget({super.key, this.size = 25});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: -0.087, // -5 degrees
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.redGlow,
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            text: 'ملاعب',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w800,
              fontSize: size,
              color: Colors.white,
            ),
            children: const [
              TextSpan(
                text: '.',
                style: TextStyle(color: AppColors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LivePill extends StatefulWidget {
  final String text;
  final bool compact;
  const LivePill({super.key, this.text = "بث مباشر الآن", this.compact = false});

  @override
  State<LivePill> createState() => _LivePillState();
}

class _LivePillState extends State<LivePill> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 8 : 12,
        vertical: widget.compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.redBadgeBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x59FF4848)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withOpacity(0.3 + (_controller.value * 0.4)),
                      blurRadius: 6 + (_controller.value * 6),
                      spreadRadius: 1 + (_controller.value * 2),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 7),
          Text(
            widget.text,
            style: TextStyle(
              color: const Color(0xFFFF6868),
              fontSize: widget.compact ? 11 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TeamBadgeWidget extends StatelessWidget {
  final String code;
  final String colorHex;
  final bool isSmall;

  const TeamBadgeWidget({
    super.key,
    required this.code,
    required this.colorHex,
    this.isSmall = false,
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
    return const Color(0xFF1478E9);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseColor(colorHex);
    final isLight = bgColor.computeLuminance() > 0.6;
    final size = isSmall ? 34.0 : 53.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
          width: isSmall ? 2 : 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          code,
          style: TextStyle(
            fontSize: isSmall ? 10 : 15,
            fontWeight: FontWeight.w800,
            color: isLight ? const Color(0xFF101116) : Colors.white,
          ),
        ),
      ),
    );
  }
}

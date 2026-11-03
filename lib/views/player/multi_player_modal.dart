import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/brand_widget.dart';

class MultiPlayerModal extends StatefulWidget {
  final VoidCallback onClose;

  const MultiPlayerModal({
    super.key,
    required this.onClose,
  });

  @override
  State<MultiPlayerModal> createState() => _MultiPlayerModalState();
}

class _MultiPlayerModalState extends State<MultiPlayerModal> {
  final Map<int, VideoPlayerController> _controllers = {};
  int _activeAudioIndex = 0;
  bool _isQuadMode = true; // true = 4 slots (2x2), false = 2 slots (2x1)

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    final provider = context.read<AppProvider>();
    for (int i = 0; i < provider.multiSlots.length; i++) {
      final slot = provider.multiSlots[i];
      if (slot != null && !_controllers.containsKey(i)) {
        _startSlotController(i, slot['url'] ?? '', slot['headers']);
      }
    }
  }

  Future<void> _startSlotController(int index, String url, Map<String, String>? headers) async {
    try {
      final ctrl = VideoPlayerController.networkUrl(
        Uri.parse(url),
        httpHeaders: headers ?? {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 14; Mobile)',
        },
      );
      await ctrl.initialize();
      ctrl.play();
      ctrl.setLooping(true);
      ctrl.setVolume(index == _activeAudioIndex ? 1.0 : 0.0);

      if (mounted) {
        setState(() {
          _controllers[index] = ctrl;
        });
      }
    } catch (_) {}
  }

  void _selectActiveAudio(int index) {
    setState(() {
      _activeAudioIndex = index;
    });
    for (final entry in _controllers.entries) {
      entry.value.setVolume(entry.key == index ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final slotsCount = _isQuadMode ? 4 : 2;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.92,
        constraints: const BoxConstraints(maxWidth: 1200),
        decoration: BoxDecoration(
          color: const Color(0xFF0C0D12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 40,
              offset: Offset(0, 15),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF14151D),
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.15),
                          border: Border.all(color: AppColors.red),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.grid_view_rounded, size: 14, color: AppColors.red),
                            SizedBox(width: 5),
                            Text(
                              "بث متعدد",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "مشاهدة حتى 4 مباريات وقنوات في نفس اللحظة",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDim,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Toggle 2 or 4 screens
                      ActionChip(
                        label: Text(_isQuadMode ? "4 شاشات (رباعي)" : "شاشتان (ثنائي)"),
                        labelStyle: const TextStyle(fontSize: 11, color: Colors.white),
                        backgroundColor: const Color(0xFF242630),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        onPressed: () {
                          setState(() {
                            _isQuadMode = !_isQuadMode;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Video Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: _isQuadMode ? (16 / 10) : (16 / 9),
                  ),
                  itemCount: slotsCount,
                  itemBuilder: (context, index) {
                    final slot = provider.multiSlots[index];
                    final ctrl = _controllers[index];
                    final isAudioActive = _activeAudioIndex == index;

                    if (slot != null && ctrl != null && ctrl.value.isInitialized) {
                      return _buildActiveSlot(index, slot, ctrl, isAudioActive, provider);
                    } else if (slot != null) {
                      return _buildLoadingSlot(index, slot, provider);
                    } else {
                      return _buildEmptySlot(index, provider);
                    }
                  },
                ),
              ),
            ),

            // Bottom Audio Indicator bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF111218),
              child: Row(
                children: [
                  const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.red),
                  const SizedBox(width: 8),
                  Text(
                    "الصوت النشط: الشاشة رقم ${_activeAudioIndex + 1} (${provider.multiSlots[_activeAudioIndex]?['title'] ?? 'فارغ'})",
                    style: const TextStyle(fontSize: 12, color: AppColors.textDim),
                  ),
                  const Spacer(),
                  const Text(
                    "اضغط على أيقونة السماعة لنقل الصوت لأي شاشة",
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSlot(
    int index,
    Map<String, dynamic> slot,
    VideoPlayerController ctrl,
    bool isAudioActive,
    AppProvider provider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAudioActive ? AppColors.red : AppColors.border,
          width: isAudioActive ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(ctrl),

          // Header over video
          Positioned(
            top: 6,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        slot['title'] ?? 'بث #${index + 1}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Audio toggle
                    InkWell(
                      onTap: () => _selectActiveAudio(index),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isAudioActive ? AppColors.red : Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          isAudioActive ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Remove slot
                    InkWell(
                      onTap: () {
                        _controllers[index]?.dispose();
                        _controllers.remove(index);
                        provider.removeMultiSlot(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.close_rounded, size: 15, color: Colors.white),
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

  Widget _buildLoadingSlot(int index, Map<String, dynamic> slot, AppProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14151B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.red, strokeWidth: 2),
            const SizedBox(height: 10),
            Text(
              "جاري تشغيل: ${slot['title']}",
              style: const TextStyle(fontSize: 12, color: AppColors.textDim),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySlot(int index, AppProvider provider) {
    return InkWell(
      onTap: () => _showAddStreamPicker(index, provider),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121319),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF1E202B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, size: 24, color: AppColors.red),
            ),
            const SizedBox(height: 8),
            Text(
              "إضافة بث للشاشة #${index + 1}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            const Text(
              "اختر مباراة أو قناة",
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStreamPicker(int slotIndex, AppProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 420,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "اختر بث للشاشة رقم ${slotIndex + 1}",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white54),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(color: AppColors.border),
                const SizedBox(height: 6),
                const Text(
                  "المباريات المباشرة الآن",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.red),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: ListView(
                    children: [
                      ...provider.liveMatches.map((m) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          leading: const Icon(Icons.sports_soccer_rounded, color: AppColors.red),
                          title: Text("${m.home} ضد ${m.away}", style: const TextStyle(color: Colors.white, fontSize: 13)),
                          subtitle: Text(m.league, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          trailing: const Icon(Icons.add_circle_outline_rounded, color: Colors.white70),
                          onTap: () {
                            Navigator.pop(ctx);
                            provider.setMultiSlot(slotIndex, {
                              "title": "${m.home} ضد ${m.away}",
                              "url": m.streamUrl ?? '',
                            });
                            _startSlotController(slotIndex, m.streamUrl ?? '', null);
                          },
                        );
                      }),
                      const SizedBox(height: 10),
                      const Text(
                        "القنوات المباشرة",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.red),
                      ),
                      const SizedBox(height: 6),
                      ...provider.channels.take(8).map((c) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          leading: const Icon(Icons.tv_rounded, color: Colors.white70),
                          title: Text(c.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          subtitle: Text(c.tag, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          trailing: const Icon(Icons.add_circle_outline_rounded, color: Colors.white70),
                          onTap: () {
                            Navigator.pop(ctx);
                            provider.setMultiSlot(slotIndex, {
                              "title": c.name,
                              "url": c.streamUrl ?? '',
                            });
                            _startSlotController(slotIndex, c.streamUrl ?? '', null);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

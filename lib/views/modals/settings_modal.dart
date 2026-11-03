import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';

class SettingsModalWidget extends StatefulWidget {
  final VoidCallback onClose;

  const SettingsModalWidget({
    super.key,
    required this.onClose,
  });

  @override
  State<SettingsModalWidget> createState() => _SettingsModalWidgetState();
}

class _SettingsModalWidgetState extends State<SettingsModalWidget> {
  final TextEditingController _fgCodeController = TextEditingController(text: "202122");
  bool _isActivating = false;
  String _statusMessage = "";
  bool _isSuccess = false;

  Future<void> _handleActivation(AppProvider provider) async {
    final code = _fgCodeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isActivating = true;
      _statusMessage = "جاري تفعيل الرمز والاتصال بالسيرفرات المشفرة...";
    });

    final success = await provider.activateFgCode(code);

    if (mounted) {
      setState(() {
        _isActivating = false;
        _isSuccess = success;
        if (success) {
          _statusMessage = "تم تفعيل الرمز بنجاح! تم تحديث قائمة القنوات والمباريات.";
        } else {
          _statusMessage = "تعذر تفعيل الرمز عبر السيرفر الرئيسي. تم استخدام القوائم الاحتياطية.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF101117),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 35,
              offset: Offset(0, 15),
            ),
          ],
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.settings_rounded, color: AppColors.red, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "إعدادات ملاعب.",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.border),
            const SizedBox(height: 14),

            // FG Code Input Section
            const Text(
              "رمز تفعيل السيرفرات (FG Code):",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              "أدخل رمز التفعيل المشفر لاستيراد باقات وسيرفرات البث المباشر (مثل رمز Drama Live الشائع: 202122)",
              style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fgCodeController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF171922),
                      hintText: "مثال: 202122",
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isActivating ? null : () => _handleActivation(provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isActivating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          "تفعيل",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ],
            ),

            if (_statusMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _isSuccess ? const Color(0xFF14301C) : const Color(0xFF2E1919),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _isSuccess ? Colors.green : AppColors.red),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSuccess ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                      size: 16,
                      color: _isSuccess ? Colors.greenAccent : Colors.redAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 11,
                          color: _isSuccess ? Colors.greenAccent : Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),

            // Features Info
            _buildSettingRow(
              icon: Icons.block_flipped,
              title: "حظر الإعلانات المزعجة",
              subtitle: "مفعل دائماً تلقائياً (Zero Ads)",
              trailing: const Icon(Icons.check_rounded, color: Colors.green, size: 20),
            ),
            const SizedBox(height: 10),
            _buildSettingRow(
              icon: Icons.shield_outlined,
              title: "تجاوز الحظر الذكي (Anti-Leech)",
              subtitle: "حقن ترويسات مشفرة تلقائياً في المشغل",
              trailing: const Icon(Icons.check_rounded, color: Colors.green, size: 20),
            ),
            const SizedBox(height: 10),
            _buildSettingRow(
              icon: Icons.tv_rounded,
              title: "دعم شاشات Android TV",
              subtitle: "متوافق مع أجهزة الاستقبال والريموت كنترول",
              trailing: const Icon(Icons.check_rounded, color: Colors.green, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textDim, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

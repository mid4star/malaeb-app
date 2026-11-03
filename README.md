# ملاعب. (Malaeb) - Next-Gen Live Sports & Channels Platform

> **نسخة حصرية فائقة الأداء مستوحاة من الهندسة العكسية لتطبيق Drama Live مع واجهة سينمائية OLED وتجربة مستخدم عصرية بالكامل خالية تماماً من الإعلانات.**

---

## 🌟 نظرة عامة (Overview)

تم بناء تطبيق **"ملاعب."** ليقدم بديلاً متطوراً واحترافياً لتطبيقات البث المباشر التقليدية، حيث يجمع بين:
1. **قوة البروتوكولات المستخلصة عبر الهندسة العكسية لـ Drama Live (v13.0.3)** لتشغيل البثوث المباشرة عبر سيرفرات الـ API المشفرة وفك الحجب عبر تقنية حقن الترويسات الذكية (Anti-Leech Header Injection).
2. **تصميم سينمائي فائق الفخامة (Cinema OLED Dark)** مستوحى من أحدث نماذج Figma التفاعلية، بلغة عربية كاملة (RTL) وخط **Tajawal** العربي العصري مع درجات تباين محسوبة خصيصاً لشاشات الهواتف وأجهزة التلفاز الذكية (Android TV).
3. **أداء 120 FPS بدون إعلانات أو برمجيات تتبع (Ad-Free & Zero Bloatware)**.

---

## 🔬 نتائج الهندسة العكسية لـ Drama Live (Reverse Engineering Insights)

من خلال فحص وتفكيك الـ Dalvik Bytecode في حزم `classes.dex`:
- **خوارزمية التشفير الأساسية:**
  - الخوارزمية: `AES-128-CBC` مع حشو `PKCS7/PKCS5`.
  - المفتاح (Secret Key): `"0123456789abcdef"`
  - متجه التهيئة (Initial Vector): `"fedcba9876543210"`
  - صيغة الحزم المرسلة والمستقبلة: `Base64(IV):Base64(Ciphertext)`
- **سيرفرات الـ API المكتشفة:**
  - سيرفر التوجيه والإعدادات: `http://main.eastgoessouth.online/api/live/livedrama/v13.0.0/`
  - سيرفر البثوث الحية: `http://live.eastgoessouth.online/api/live/livedrama/v13.0.0/`
  - سيرفر المباريات الرياضية: `http://sport.eastgoessouth.online/sport/`
  - سيرفر إعادة التوجيه وفك الروابط: `http://redirect.eastgoessouth.online/redirect/`
- **آلية تجاوز قيود الحماية (Anti-Leech Bypass):**
  - تتطلب روابط البث عالية الجودة تمرير ترويسات `User-Agent` و `Referer` مخصصة عند طلب ملفات التجزئة `.m3u8` أو `.ts` لتفادي كود الحظر `403 Forbidden`. تم دمج هذه الآلية تلقائياً داخل مشغل التطبيق.

---

## ⚡ مميزات تطبيق "ملاعب."

- **🎬 واجهة سينمائية OLED متطورة:**
  - ألوان عميقة (`#08090C`, `#111218`) لتقليل استهلاك البطارية وإبراز جمالية المحتوى الرياضي.
  - لون تمييز أحمر قرمزي نابض (`#FF3B3B`) مع تأثيرات Glow زجاجية خفيفة.
- **🖥️ ميزة البث المتعدد الرباعي (Quad Multi-View):**
  - إمكانية تشغيل حتى **4 مباريات وقنوات في نفس اللحظة** على شاشة واحدة (خاصية ثورية لأجهزة Android TV والشاشات اللوحية).
  - تبديل سلس لمصدر الصوت بنقرة واحدة لأي شاشة بدون انقطاع البث.
- **⚽ قسم مباشر ومباريات متكامل:**
  - عرض تفصيلي لنتيجة المباراة، الدقيقة المباشرة، شعارات الفرق، وأسماء المعلقين والقنوات الناقلة.
  - جدول مباريات شامل بثلاثة تصنيفات (أمس / اليوم / الغد) مع ميزة تفعيل التنبيهات (Reminders).
- **📺 دليل القنوات الشامل:**
  - تصنيفات متعددة (رياضية، إخبارية، ترفيه، وثائقيات، أطفال).
  - بحث فوري ذكي وسريع بالاسم والتصنيف.
- **🍿 سينما ووثائقيات رياضية:**
  - مكتبة لأهم الأفلام الوثائقية الرياضية وملخصات البطولات العالمية.

---

## 📁 هيكلية المشروع (Architecture)

```text
malaeb_app/
├── android/                   # إعدادات Android و Android TV Leanback
│   └── app/src/main/AndroidManifest.xml
├── assets/                    # الخطوط والصور
├── lib/
│   ├── main.dart             # نقطة الانطلاق وإعداد الـ RTL و Theme
│   ├── core/
│   │   ├── crypto/
│   │   │   └── drama_crypto.dart   # تنفيذ AES-128-CBC المتطابق 100% مع Drama Live
│   │   ├── services/
│   │   │   └── api_service.dart    # استدعاء السيرفرات وفك الروابط وتوجيه الترويسات
│   │   └── theme/
│   │       └── app_theme.dart      # نظام الألوان وتنسيق خط Tajawal
│   ├── models/
│   │   ├── match_model.dart        # نماذج المباريات المباشرة والجدول
│   │   ├── channel_model.dart      # نماذج القنوات والتصنيفات
│   │   └── movie_model.dart        # نماذج الأفلام والوثائقيات
│   ├── providers/
│   │   └── app_provider.dart       # إدارة الحالة (State Management)
│   └── views/
│       ├── widgets/               # المكونات الرسومية المشتركة
│       │   ├── brand_widget.dart   # شعار ملاعب ومؤشر LivePill
│       │   ├── section_title.dart  # عناوين الأقسام مع الخط الأحمر
│       │   ├── match_card.dart     # بطاقات المباريات
│       │   ├── schedule_row.dart   # صفوف جدول المباريات
│       │   ├── channel_card.dart   # بطاقات القنوات
│       │   └── movie_card.dart     # بطاقات الأفلام
│       ├── player/
│       │   ├── video_player_modal.dart   # المشغل الفردي مع حقن الترويسات
│       │   └── multi_player_modal.dart   # المشغل الرباعي المتعدد (Quad-View)
│       ├── modals/
│       │   └── search_modal.dart         # نافذة البحث السريع الفوري
│       └── screens/
│           ├── home_screen.dart          # الواجهة الرئيسية والهيرو
│           ├── live_screen.dart          # صفحة المباشر وتصفية الدوريات
│           ├── channels_screen.dart      # صفحة القنوات
│           ├── schedule_screen.dart      # جدول المباريات
│           ├── entertainment_screen.dart # قسم الترفيه
│           └── main_navigation_screen.dart # القائمة العلوية والشريط السفلي
└── pubspec.yaml              # حزم Flutter المعتمدة
```

---

## 🚀 طريقة البناء والتشغيل (How to Build & Run)

### 1. المتطلبات:
- تثبيت Flutter SDK (الإصدار 3.0.0 وما فوق).
- بيئة Android Studio أو Flutter CLI.

### 2. تثبيت الحزم:
```bash
cd malaeb_app
flutter pub get
```

### 3. التشغيل في وضع التطوير (Debug):
```bash
flutter run
```

### 4. بناء ملف تثبيت Android APK (Release):
```bash
flutter build apk --release
```
أو لبناء حزمة خفيفة مخصصة لمعمارية ARM64:
```bash
flutter build apk --split-per-abi --release
```
الملف الناتج سيكون متاحاً في:
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

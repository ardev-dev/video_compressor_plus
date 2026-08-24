# لماذا هذا الفورك؟

نسخة عن [`jonataslaw/VideoCompress`](https://github.com/jonataslaw/VideoCompress)
تضيف **دعم Swift Package Manager** فقط، بلا أي تغيير في السلوك.

## السبب

الأصل مهجور عملياً: آخر إصدار `3.1.4` في 2025-02-13، وآخر دفع للمستودع في
التاريخ نفسه، و208 مسائل مفتوحة. وقُدِّمت **أربع** محاولات لإضافة دعم SPM ولم
يُدمج أيٌّ منها.

ومشروعا «عبر» (`Abber-App` و`abber_admin`) هاجرا إلى SPM؛ ولم يبقَ في
CocoaPods إلا `Flutter` و`video_compress` نفسه. أي أن هذه الحزمة وحدها هي ما
يُبقي نظام بناء كاملاً حيّاً. وFlutter يحذّر:

> The following plugins do not support Swift Package Manager for ios:
> `video_compress` — This will become an error in a future version of Flutter.

## ما الذي أُضيف

دُمج حرفياً [PR #325](https://github.com/jonataslaw/VideoCompress/pull/325)
(«Add Swift Package Manager support (iOS + macOS)»): إعادة هيكلة `ios/Classes`
و`macos/Classes` إلى بنية SPM مع `Package.swift`، وحذف غلافَي Objective-C
القديمين. **لا تغيير في أي منطق ضغط أو قصّ.**

## لماذا لم نستبدلها بـffmpeg؟

`ffmpeg_kit_flutter_new` مصان ويدعم SPM، لكن نسخته الافتراضية **GPL v3**
(تضمّ x264/x265) وهي غير صالحة لتطبيق مغلق المصدر على App Store. والنسخة
`_min` رخصتها LGPL ومقبولة، لكنها تضيف **٢٠–٤٠ ميغا** إلى حجم التطبيق لأجل
قصٍّ وكتم صوتٍ في شاشة واحدة. الفورك يكلّف صفر ميغابايت وصفر تغيير سلوك.

## الاستخدام في التطبيق

```yaml
video_compress:
  git:
    url: https://github.com/zinon-software/video_compress.git
    ref: stable
```

## المزامنة مع الأصل

```bash
git fetch upstream && git merge upstream/master
```
لا يُتوقَّع نشاط في الأصل، لكن أبقِ `upstream` مضبوطاً تحسّباً.

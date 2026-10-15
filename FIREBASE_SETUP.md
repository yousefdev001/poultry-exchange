# دليل إعداد Firebase لتطبيق أسعار دواجن الشمس

## الخطوة 1: إنشاء مشروع Firebase

1. اذهب إلى https://console.firebase.google.com
2. اضغط "Add project"
3. اسم المشروع: `elshams-prices` (أو أي اسم تفضله)
4. أكمل الإعداد

---

## الخطوة 2: إضافة Android App

1. في Firebase Console: Project Settings → Add App → Android
2. Android package name: `com.elshams.app`
3. حمّل ملف `google-services.json`
4. ضعه في: `android/app/google-services.json`

---

## الخطوة 3: تشغيل FlutterFire CLI (الأفضل)

```bash
# تثبيت CLI
dart pub global activate flutterfire_cli

# تهيئة Firebase
flutterfire configure --project=YOUR_PROJECT_ID
```

هذا يولّد `lib/firebase_options.dart` تلقائياً.

---

## الخطوة 4: تفعيل Firestore

1. Firebase Console → Firestore Database → Create database
2. اختر "Start in production mode"
3. اختر الـ region الأقرب (مثل `europe-west1`)

---

## الخطوة 5: رفع Firestore Security Rules

1. Firebase Console → Firestore → Rules
2. انسخ محتوى ملف `firestore.rules` والصقه
3. اضغط "Publish"

---

## الخطوة 6: تفعيل Authentication

1. Firebase Console → Authentication → Sign-in method
2. فعّل: Email/Password

---

## الخطوة 7: إنشاء حساب Admin

### من Firebase Console:
1. Authentication → Users → Add user
   - Email: `admin@elshams.com`
   - Password: كلمة مرور قوية (12+ حرف)

### إضافة بيانات Firestore للـ user:
1. Firestore → users collection → New document
   - Document ID: [uid من Firebase Auth]
   - Fields:
     - email: "admin@elshams.com"
     - role: "admin"
     - isActive: true
     - createdAt: (server timestamp)

---

## الخطوة 8: Seed البيانات الافتراضية

### إضافة سعر الحي:
Firestore → settings → live_price:
```json
{
  "livePrice": 100.0,
  "updatedAt": (server timestamp),
  "updatedBy": "admin@elshams.com"
}
```

### إضافة الأصناف:
Firestore → products:
اضف 10 documents مع هذه البيانات:

| name | multiplier | increase | isActive | order |
|------|-----------|----------|----------|-------|
| فراخ كاملة | 1.60 | 25 | true | 0 |
| صدور بالعظم | 1.55 | 25 | true | 1 |
| ورك عادة | 1.25 | 20 | true | 2 |
| ورك مقصف | 1.45 | 25 | true | 3 |
| دبوس | 1.30 | 20 | true | 4 |
| شيش بالجلد | 1.65 | 30 | true | 5 |
| شيش كامل بدون جلد | 1.80 | 30 | true | 6 |
| فيليه | 2.95 | 25 | true | 7 |
| شاورما مسحب | 2.10 | 25 | true | 8 |
| صدور فيليه بالجلد | 2.70 | 25 | true | 9 |

(أضف أيضاً: createdAt, updatedAt, createdBy, updatedBy)

---

## الخطوة 9: تشغيل التطبيق

```bash
flutter pub get
flutter run
```

---

## الوصول للوحة الإدارة

لوحة الإدارة **مخفية** من الـ Navigation العادي.
الرابط: **اضغط 7 مرات** على اسم التطبيق في الـ Header أو انتقل مباشرة لـ:
`/elshams-admin-login`

---

## أمان مهم

- **لا تشارك** كلمة مرور Admin
- **لا تضع** `google-services.json` في GitHub العام
- **أضف** `.gitignore` يستثني هذا الملف
- استخدم Firestore Security Rules كطبقة حماية أساسية
- الـ Multiplier والـ Increase محمية بـ Security Rules
  (لكن إذا أراد أحد قراءتها من Firestore مباشرة يستطيع — لذلك الحساب يتم في Flutter Domain Layer بشكل صحيح)

// ============================================================
// app_strings.dart — جميع النصوص العربية في مكان واحد
// ============================================================

class AppStrings {
  AppStrings._();

  // --- App ---
  static const String appName = 'أسعار دواجن الشمس';
  static const String appTagline = 'الشمس لانتاج مصنعات اللحوم والدواجن';

  // --- Home ---
  static const String livePriceTitle = 'سعر اللحم الحي';
  static const String frozenPricesTitle = 'أسعار الدجاج المجمد والفريش';
  static const String currency = 'جنيه';
  static const String lastUpdated = 'آخر تحديث';

  // --- Loading/Error States ---
  static const String loading = 'جارٍ التحميل...';
  static const String loadingPrices = 'جارٍ تحميل الأسعار...';
  static const String errorLoading = 'تعذر تحميل الأسعار';
  static const String errorTitle = 'حدث خطأ';
  static const String retry = 'إعادة المحاولة';
  static const String noProducts = 'لا توجد أصناف حاليًا';
  static const String noPriceAvailable = 'السعر غير متاح حاليًا';
  static const String serverError = 'حدث خطأ في الاتصال بالخادم';
  static const String unknownError = 'حدث خطأ غير متوقع';

  // --- Offline ---
  static const String noInternet = 'لا يوجد اتصال بالإنترنت';
  static const String offlineMessage = 'يتم عرض آخر أسعار تم تحميلها';
  static const String offlineData = 'البيانات المعروضة قد لا تكون محدّثة';
  static const String connectToUpdate = 'اتصل بالإنترنت لتحديث الأسعار';

  // --- Auth ---
  static const String adminLogin = 'تسجيل الدخول للإدارة';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String loginButton = 'تسجيل الدخول';
  static const String loginLoading = 'جارٍ تسجيل الدخول...';
  static const String logout = 'تسجيل الخروج';
  static const String logoutConfirm = 'هل أنت متأكد من تسجيل الخروج؟';

  // --- Auth Errors ---
  static const String emailRequired = 'يرجى إدخال البريد الإلكتروني';
  static const String emailInvalid = 'يرجى إدخال بريد إلكتروني صحيح';
  static const String passwordRequired = 'يرجى إدخال كلمة المرور';
  static const String passwordTooShort =
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  static const String invalidCredentials = 'بيانات تسجيل الدخول غير صحيحة';
  static const String notAdmin = 'ليس لديك صلاحية الوصول للوحة الإدارة';
  static const String sessionExpired =
      'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مجدداً';
  static const String unauthorized = 'غير مصرح لك بهذا الإجراء';

  // --- Admin Dashboard ---
  static const String adminDashboard = 'لوحة الإدارة';
  static const String overview = 'نظرة عامة';
  static const String currentLivePrice = 'سعر اللحم الحي';
  static const String activeProducts = 'الأصناف الفعالة';
  static const String inactiveProducts = 'الأصناف المعطلة';
  static const String lastUpdate = 'آخر تحديث';
  static const String editLivePrice = 'تعديل السعر';
  static const String editLivePriceTitle = 'تعديل سعر اللحم الحي';
  static const String currentPrice = 'السعر الحالي';
  static const String newPrice = 'السعر الجديد';
  static const String saveChange = 'حفظ التغيير';
  static const String cancel = 'إلغاء';
  static const String save = 'حفظ';
  static const String confirm = 'تأكيد';

  // --- Confirm Dialogs ---
  static const String confirmChangePriceTitle = 'تأكيد تغيير السعر';
  static const String confirmChangePriceBody =
      'هل أنت متأكد من تغيير سعر اللحم الحي؟ سيؤثر ذلك على أسعار جميع الأصناف.';
  static const String confirmDisableProductTitle = 'تأكيد تعطيل الصنف';
  static const String confirmDisableProductBody =
      'هل أنت متأكد من تعطيل هذا الصنف؟ سيختفي من قائمة المستخدمين.';
  static const String confirmEnableProductTitle = 'تأكيد تفعيل الصنف';
  static const String confirmEnableProductBody =
      'هل أنت متأكد من تفعيل هذا الصنف؟ سيظهر في قائمة المستخدمين.';
  static const String confirmLogoutTitle = 'تسجيل الخروج';
  static const String confirmLogoutBody =
      'هل أنت متأكد من تسجيل الخروج من لوحة الإدارة؟';
  static const String disable = 'تعطيل';
  static const String enable = 'تفعيل';

  // --- Success Messages ---
  static const String priceUpdatedSuccess = 'تم تحديث سعر اللحم الحي بنجاح';
  static const String productAddedSuccess = 'تم إضافة الصنف بنجاح';
  static const String productUpdatedSuccess = 'تم تعديل الصنف بنجاح';
  static const String productDisabledSuccess = 'تم تعطيل الصنف بنجاح';
  static const String productEnabledSuccess = 'تم تفعيل الصنف بنجاح';
  static const String logoutSuccess = 'تم تسجيل الخروج بنجاح';

  // --- Products ---
  static const String productsManagement = 'إدارة الأصناف';
  static const String addProduct = 'إضافة صنف';
  static const String addProductTitle = 'إضافة صنف جديد';
  static const String editProduct = 'تعديل الصنف';
  static const String productName = 'اسم الصنف';
  static const String multiplier = 'النسبة';
  static const String increase = 'الزيادة';
  static const String status = 'الحالة';
  static const String actions = 'الإجراءات';
  static const String active = 'فعال';
  static const String inactive = 'غير فعال';
  static const String saveProduct = 'إضافة الصنف';
  static const String saveEdits = 'حفظ التعديلات';

  // --- Validation ---
  static const String productNameRequired = 'اسم الصنف مطلوب';
  static const String productNameEmpty = 'اسم الصنف لا يمكن أن يكون فارغًا';
  static const String multiplierRequired = 'النسبة مطلوبة';
  static const String multiplierInvalid = 'يرجى إدخال نسبة صحيحة (مثال: 1.60)';
  static const String multiplierMustBePositive =
      'النسبة يجب أن تكون أكبر من صفر';
  static const String increaseRequired = 'الزيادة مطلوبة';
  static const String increaseInvalid = 'يرجى إدخال قيمة زيادة صحيحة';
  static const String increaseNegative = 'الزيادة لا يمكن أن تكون سالبة';
  static const String priceRequired = 'السعر مطلوب';
  static const String priceInvalid = 'يرجى إدخال سعر صحيح';
  static const String priceMustBePositive = 'السعر يجب أن يكون أكبر من صفر';

  // --- Audit Logs ---
  static const String auditLogs = 'سجل التعديلات';
  static const String noLogs = 'لا توجد تعديلات مسجلة';
  static const String performedBy = 'بواسطة';
  static const String oldValue = 'القيمة القديمة';
  static const String newValue = 'القيمة الجديدة';

  // --- Audit Actions ---
  static const String actionUpdateLivePrice = 'تغيير سعر الحي';
  static const String actionAddProduct = 'إضافة صنف';
  static const String actionUpdateProduct = 'تعديل صنف';
  static const String actionDisableProduct = 'تعطيل صنف';
  static const String actionEnableProduct = 'تفعيل صنف';

  // --- Account ---
  static const String account = 'الحساب';
  static const String accountStatus = 'حالة الحساب';
  static const String adminRole = 'مدير النظام';
  static const String loggedInAs = 'مسجل الدخول كـ';

  // --- Navigation ---
  static const String home = 'الرئيسية';
  static const String products = 'الأصناف';
  static const String logs = 'السجل';

  // --- General ---
  static const String today = 'اليوم';
  static const String yes = 'نعم';
  static const String no = 'لا';
  static const String close = 'إغلاق';
  static const String search = 'بحث';
  static const String refresh = 'تحديث';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
}

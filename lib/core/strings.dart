import 'package:flutter/widgets.dart';
import 'app_state.dart';

// key: [English, Arabic]
const Map<String, List<String>> _s = {
  // nav
  'home': ['Home', 'الرئيسية'],
  'shop': ['Shop', 'المتجر'],
  'about': ['About', 'من نحن'],
  'contact': ['Contact', 'تواصل معنا'],
  'faq': ['FAQ', 'الأسئلة الشائعة'],
  'shippingReturns': ['Shipping & Returns', 'الشحن والإرجاع'],
  'privacy': ['Privacy Policy', 'سياسة الخصوصية'],
  'terms': ['Terms of Service', 'شروط الخدمة'],
  'bag': ['Bag', 'السلة'],
  'menu': ['Menu', 'القائمة'],
  'langName': ['العربية', 'English'],
  'brandName': ['Khayt', 'خيط'],
  'brandTag': ['Fashion Atelier', 'أتيليه الأزياء'],
  'announce': [
    'Free shipping over \$120  ·  Fictional demo store, no real orders or payments',
    'شحن مجاني فوق ١٢٠\$  ·  متجر وهمي للعرض فقط، بدون طلبات أو مدفوعات حقيقية'
  ],
  // hero
  'heroEyebrow': ['AUTUMN / WINTER 2026', 'خريف / شتاء ٢٠٢٦'],
  'heroTitle1': ['Knit for the way', 'حياكة تناسب'],
  'heroTitle2': ['you move.', 'حركتك.'],
  'heroSub': [
    'Soft knits, honest fabrics and silhouettes made to last. Turn the sweater, pick a colour, and watch the whole store change with it.',
    'حياكة ناعمة وأقمشة صادقة وقصّات تدوم. دوّر السويتر، اختر لوناً، وشاهد المتجر كله يتغيّر معه.'
  ],
  'shopNow': ['Shop the collection', 'تسوّق المجموعة'],
  'tryIn3d': ['Try it in 3D', 'جرّبه بالـ 3D'],
  'heroColor': ['Pick a colour. The whole store follows.', 'اختر لوناً. والمتجر كله يتبعك.'],
  'drag3d': ['Drag to rotate', 'اسحب للتدوير'],
  'viewDetails': ['View details', 'عرض التفاصيل'],
  'liveColor': ['Colour', 'اللون'],
  // sections
  'railTitle': ['The Rail', 'الشماعة'],
  'railSub': [
    'Drag or scroll the rail. The pieces sway like real garments on hangers.',
    'اسحب أو مرّر الشماعة، وشاهد القطع تتمايل كأنها معلّقة.'
  ],
  'shopByCat': ['Shop by category', 'تسوّق حسب الفئة'],
  'women': ['Women', 'نساء'],
  'men': ['Men', 'رجال'],
  'knitwear': ['Knitwear', 'تريكو'],
  'accessories': ['Accessories', 'إكسسوارات'],
  'all': ['All', 'الكل'],
  'newArrivals': ['New arrivals', 'وصل حديثاً'],
  'viewAll': ['View all', 'عرض الكل'],
  'pieces': ['pieces', 'قطعة'],
  'valuesTitle': ['Made slowly, worn for years', 'تُصنع ببطء وتُلبس لسنوات'],
  'value1t': ['Honest fabrics', 'أقمشة صادقة'],
  'value1d': [
    'Merino, organic cotton and recycled fibres. Every label tells you exactly what is inside.',
    'ميرينو وقطن عضوي وألياف معاد تدويرها. كل بطاقة تخبرك بالضبط بما بداخلها.'
  ],
  'value2t': ['Fair making', 'صناعة عادلة'],
  'value2d': [
    'Small partner workshops, fair wages and short supply chains we can actually visit.',
    'ورشات شريكة صغيرة وأجور عادلة وسلاسل توريد قصيرة نستطيع زيارتها فعلاً.'
  ],
  'value3t': ['30-day returns', 'إرجاع خلال ٣٠ يوماً'],
  'value3d': [
    'Wear it, test it, change your mind. Free returns on every order, no questions asked.',
    'البسها وجرّبها وغيّر رأيك. إرجاع مجاني على كل طلب بدون أسئلة.'
  ],
  'loveTitle': ['Words from our (imaginary) customers', 'كلمات من زبائننا (الخياليين)'],
  'newsletterTitle': ['First access to new drops', 'أول من يعرف بالجديد'],
  'newsletterSub': ['Join the list. Fictional newsletter, nothing is sent.', 'انضم للقائمة. نشرة وهمية، لن يُرسل شيء.'],
  'emailPlaceholder': ['Your email address', 'بريدك الإلكتروني'],
  'subscribe': ['Subscribe', 'اشترك'],
  'subscribed': ['Thanks! (This is a demo, nothing was stored.)', 'شكراً! (هذا عرض تجريبي ولم يُحفظ شيء.)'],
  // shop
  'sortBy': ['Sort by', 'ترتيب حسب'],
  'sortFeatured': ['Featured', 'المميز'],
  'sortNewest': ['Newest', 'الأحدث'],
  'sortPriceLow': ['Price: low to high', 'السعر: من الأقل'],
  'sortPriceHigh': ['Price: high to low', 'السعر: من الأعلى'],
  'sortRating': ['Top rated', 'الأعلى تقييماً'],
  'results': ['items', 'منتج'],
  'noResults': ['Nothing matches your search.', 'لا شيء يطابق بحثك.'],
  'search': ['Search the store', 'ابحث في المتجر'],
  'shopTitle': ['The collection', 'المجموعة'],
  'shopSub': ['Everything we make, in one place.', 'كل ما نصنعه في مكان واحد.'],
  // product
  'addToBag': ['Add to bag', 'أضف للسلة'],
  'buyNow': ['Buy now', 'اشترِ الآن'],
  'size': ['Size', 'المقاس'],
  'color': ['Colour', 'اللون'],
  'quantity': ['Quantity', 'الكمية'],
  'details': ['Details', 'التفاصيل'],
  'fabricCare': ['Fabric & care', 'القماش والعناية'],
  'shipReturnText': [
    'Free standard shipping on orders over \$120. Free returns within 30 days of delivery.',
    'شحن عادي مجاني للطلبات فوق ١٢٠\$. إرجاع مجاني خلال ٣٠ يوماً من التسليم.'
  ],
  'reviews': ['reviews', 'تقييم'],
  'inStock': ['In stock', 'متوفر'],
  'sale': ['Sale', 'تخفيض'],
  'newBadge': ['New', 'جديد'],
  'badge3d': ['3D', '3D'],
  'youMayLike': ['You may also like', 'قد يعجبك أيضاً'],
  'selectSize': ['Please choose a size', 'الرجاء اختيار المقاس'],
  'addedToBag': ['Added to your bag', 'تمت الإضافة للسلة'],
  'dragHint': ['Drag to rotate  ·  Pick a colour', 'اسحب للتدوير  ·  اختر لوناً'],
  'zoomHint': ['Move over the photo to zoom', 'حرّك المؤشر فوق الصورة للتكبير'],
  'detailView': ['Detail', 'تفصيل'],
  'flip': ['Details', 'التفاصيل'],
  'quickAdd': ['Quick add', 'إضافة سريعة'],
  'freeShipOver': ['Free shipping over \$120', 'شحن مجاني فوق ١٢٠\$'],
  // cart
  'yourBag': ['Your bag', 'سلتك'],
  'viewFullBag': ['View full bag', 'عرض السلة كاملة'],
  'emptyBag': ['Your bag is empty', 'سلتك فارغة'],
  'emptyBagSub': ['Find something you love in the collection.', 'اعثر على شيء يعجبك في المجموعة.'],
  'subtotal': ['Subtotal', 'المجموع الفرعي'],
  'discount': ['Discount', 'الخصم'],
  'shippingLabel': ['Shipping', 'الشحن'],
  'free': ['Free', 'مجاني'],
  'tax': ['Estimated tax', 'الضريبة التقديرية'],
  'total': ['Total', 'الإجمالي'],
  'promoCode': ['Promo code', 'رمز الخصم'],
  'apply': ['Apply', 'تطبيق'],
  'promoApplied': ['Code KHAYT10 applied: 10% off', 'تم تطبيق الرمز KHAYT10: خصم ١٠٪'],
  'promoInvalid': ['That code is not valid. Try KHAYT10.', 'الرمز غير صالح. جرّب KHAYT10.'],
  'checkout': ['Checkout', 'إتمام الشراء'],
  'continueShopping': ['Continue shopping', 'متابعة التسوّق'],
  'remove': ['Remove', 'إزالة'],
  'freeShipLeft': ['Add \$X more for free shipping', 'أضف X\$ للحصول على شحن مجاني'],
  'freeShipDone': ['You have free shipping!', 'حصلت على شحن مجاني!'],
  'item': ['item', 'قطعة'],
  'items': ['items', 'قطع'],
  // checkout
  'checkoutTitle': ['Secure checkout', 'إتمام الشراء الآمن'],
  'contactInfo': ['Contact', 'معلومات التواصل'],
  'email': ['Email', 'البريد الإلكتروني'],
  'phone': ['Phone (optional)', 'الهاتف (اختياري)'],
  'shipTo': ['Shipping address', 'عنوان الشحن'],
  'fullName': ['Full name', 'الاسم الكامل'],
  'address': ['Address', 'العنوان'],
  'city': ['City', 'المدينة'],
  'postal': ['Postal code', 'الرمز البريدي'],
  'country': ['Country', 'الدولة'],
  'shipMethod': ['Delivery', 'التوصيل'],
  'standardShip': ['Standard (3 to 6 business days)', 'عادي (٣ إلى ٦ أيام عمل)'],
  'expressShip': ['Express (1 to 2 business days)', 'سريع (١ إلى ٢ يوم عمل)'],
  'payment': ['Payment', 'الدفع'],
  'cardNumber': ['Card number', 'رقم البطاقة'],
  'nameOnCard': ['Name on card', 'الاسم على البطاقة'],
  'expiry': ['Expiry (MM/YY)', 'الانتهاء (شهر/سنة)'],
  'cvc': ['CVC', 'رمز الأمان CVC'],
  'payNow': ['Pay', 'ادفع'],
  'demoNote': [
    'DEMO STORE. This is a fictional shop made for a portfolio. No real payment is processed and your details never leave this page.',
    'متجر تجريبي. هذا متجر وهمي صُنع لعرض الأعمال. لا تتم أي عملية دفع حقيقية وبياناتك لا تغادر هذه الصفحة.'
  ],
  'testCardHint': ['Test card: 4242 4242 4242 4242, any future date, any CVC', 'بطاقة تجريبية: 4242 4242 4242 4242 وأي تاريخ مستقبلي وأي CVC'],
  'orderSummary': ['Order summary', 'ملخص الطلب'],
  'secureNote': ['Card details are encrypted and never stored (simulated)', 'بيانات البطاقة مشفّرة ولا تُخزّن (محاكاة)'],
  'processing': ['Processing payment...', 'جارٍ معالجة الدفع...'],
  'verifyTitle': ['Verify your payment', 'تأكيد عملية الدفع'],
  'verifySub': [
    'Your bank sent a 6-digit code to the phone ending in 42. Enter any 6 digits to continue (demo).',
    'أرسل مصرفك رمزاً من ٦ أرقام للهاتف المنتهي بـ 42. أدخل أي ٦ أرقام للمتابعة (تجريبي).'
  ],
  'verify': ['Confirm', 'تأكيد'],
  'cancel': ['Cancel', 'إلغاء'],
  'required': ['Required', 'مطلوب'],
  'invalidEmail': ['Enter a valid email', 'أدخل بريداً صالحاً'],
  'invalidCard': ['Enter a valid card number', 'أدخل رقم بطاقة صالحاً'],
  'invalidExpiry': ['Enter a valid expiry date', 'أدخل تاريخ انتهاء صالحاً'],
  'invalidCvc': ['Enter a valid CVC', 'أدخل رمز CVC صالحاً'],
  'bagEmptyCheckout': ['Your bag is empty. Add something first.', 'سلتك فارغة. أضف شيئاً أولاً.'],
  'acceptedCards': ['We accept Visa and Mastercard', 'نقبل فيزا وماستركارد'],
  // success
  'thankYou': ['Thank you for your order', 'شكراً لطلبك'],
  'orderNumber': ['Order number', 'رقم الطلب'],
  'orderConfirmedSub': [
    'A confirmation would be emailed to you. Since this is a demo, nothing was charged and nothing will ship.',
    'كان سيصلك بريد تأكيد. وبما أن هذا عرض تجريبي فلم يُخصم شيء ولن يُشحن شيء.'
  ],
  'shippedTo': ['Shipping to', 'الشحن إلى'],
  'paidWith': ['Paid with', 'الدفع بواسطة'],
  'backHome': ['Back to home', 'العودة للرئيسية'],
  'noOrder': ['No recent order to show.', 'لا يوجد طلب حديث للعرض.'],
  // footer
  'footerAbout': [
    'Khayt (Arabic for "thread") is a fictional fashion atelier created as a Flutter portfolio project: cart, card checkout and a 3D knitwear viewer.',
    'خيط أتيليه أزياء وهمي أُنشئ كمشروع لعرض الأعمال بـ Flutter: سلة وشراء ببطاقة وعارض ثلاثي الأبعاد للتريكو.'
  ],
  'helpCol': ['Help', 'مساعدة'],
  'companyCol': ['Company', 'الشركة'],
  'legalCol': ['Legal', 'قانوني'],
  'shopCol': ['Shop', 'تسوّق'],
  'rights': ['© 2026 Khayt Atelier (fictional). All rights reserved.', '© ٢٠٢٦ أتيليه خيط (وهمي). جميع الحقوق محفوظة.'],
  'fictionalNotice': [
    'Khayt is not a real company. Product photos are from Unsplash. Orders, prices and reviews are fictional.',
    'خيط ليست شركة حقيقية. صور المنتجات من Unsplash. الطلبات والأسعار والتقييمات وهمية.'
  ],
  'photoCredit': ['Photos: Unsplash', 'الصور: Unsplash'],
  // contact
  'contactTitle': ['We would love to hear from you', 'يسعدنا أن نسمع منك'],
  'contactSub': ['Questions about an order, sizing or a collaboration? Write to us.', 'أسئلة عن طلب أو مقاس أو تعاون؟ راسلنا.'],
  'yourName': ['Your name', 'اسمك'],
  'yourMessage': ['Your message', 'رسالتك'],
  'send': ['Send message', 'إرسال الرسالة'],
  'messageSent': ['Message sent. (Demo: nothing was actually sent.)', 'تم الإرسال. (تجريبي: لم يُرسل شيء فعلياً.)'],
  'visitUs': ['Studio', 'الأتيليه'],
  'writeUs': ['Write to us', 'راسلنا'],
  'callUs': ['Call us', 'اتصل بنا'],
  'hours': ['Mon to Sat, 10:00 to 18:00', 'الإثنين إلى السبت، ١٠:٠٠ إلى ١٨:٠٠'],
  // misc
  'rating': ['rating', 'التقييم'],
  'backToShop': ['Back to shop', 'العودة للمتجر'],
  'notFound': ['We could not find that page.', 'لم نعثر على هذه الصفحة.'],
  'productNotFound': ['Product not found.', 'المنتج غير موجود.'],
  'lastUpdated': ['Last updated: 1 October 2026', 'آخر تحديث: ١ أكتوبر ٢٠٢٦'],
};

String tr(BuildContext context, String key) {
  final ar = AppScope.of(context).isAr;
  final v = _s[key];
  if (v == null) return key;
  return ar ? v[1] : v[0];
}

String trLang(bool ar, String key) {
  final v = _s[key];
  if (v == null) return key;
  return ar ? v[1] : v[0];
}

bool hasKey(String key) => _s.containsKey(key);

extension TrCtx on BuildContext {
  String t(String key) => tr(this, key);
  bool get isAr => AppScope.of(this).isAr;
}

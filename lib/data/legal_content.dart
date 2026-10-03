// Fictional company details used across the legal pages.
const kCompanyEn = 'Khayt Atelier Ltd. (fictional company)';
const kCompanyAr = 'شركة أتيليه خيط المحدودة (شركة وهمية)';
const kEmail = 'hello@khayt.example';
const kPhone = '+1 (555) 010-0199';
const kAddressEn = '12 Loom Street, Studio 4, Imaginary City, 00000';
const kAddressAr = '١٢ شارع النول، الاستوديو ٤، مدينة خيالية، ٠٠٠٠٠';

class Section {
  final String h;
  final List<String> p;
  const Section(this.h, this.p);
}

// ------------------------------------------------------------ PRIVACY
const privacyEn = <Section>[
  Section('1. Who we are', [
    'Khayt ("we", "us") is a fictional fashion atelier created as a software portfolio project. This website is a demonstration only: no real products are sold, no real orders are fulfilled and no real payments are processed.',
    'This policy explains, as a real store would, what personal data a shop like this collects and how it should be protected. Contact: $kEmail.',
  ]),
  Section('2. Information we collect', [
    'Contact details such as your name, email address, phone number and delivery address when you place an order or write to us.',
    'Order details such as the items you buy, sizes, colours, order totals and delivery choices.',
    'Payment details such as the card brand and the last four digits. In a live store the full card number, expiry date and security code are entered into a PCI-DSS compliant payment provider and are never stored on our own servers.',
    'Technical data such as device type, browser, language preference and the pages you view, collected through cookies and similar technologies.',
  ]),
  Section('3. How we use your information', [
    'To process and deliver your orders, send confirmations and handle returns.',
    'To provide customer support and respond to your messages.',
    'To prevent fraud and keep the site secure, including card verification (3-D Secure).',
    'To improve the website, for example by learning which products and pages are most useful.',
    'To send marketing emails only if you have opted in. You can unsubscribe at any time.',
  ]),
  Section('4. About this demo', [
    'In this demonstration, everything you type in the checkout form stays inside your browser tab. Nothing is sent to a server, nothing is stored, and the card form validates the format of the number locally only. Please do not enter a real card number; use the test card shown on the checkout page.',
    'Your language choice and cart contents are kept in memory only and disappear when you close or refresh the page.',
  ]),
  Section('5. Cookies', [
    'A live store would use essential cookies (cart, security), preference cookies (language) and optional analytics or marketing cookies. Non-essential cookies would only be set after your consent, and you could change your choice at any time. This demo sets no tracking cookies.',
  ]),
  Section('6. Sharing your information', [
    'We never sell personal data. A real store shares data only with service providers who help it operate: payment processors, delivery carriers, email and hosting providers, and fraud-prevention services. They may only use the data to provide their service to us, under contract.',
    'We may disclose data where required by law or to protect rights, safety and property.',
  ]),
  Section('7. How long we keep it', [
    'Order and invoice records are kept for the period required by tax and accounting law (typically 6 to 10 years). Support messages are kept for up to 24 months. Marketing preferences are kept until you withdraw consent.',
  ]),
  Section('8. Your rights', [
    'Depending on where you live (for example under the GDPR or the CCPA) you can ask to access, correct, delete or export your personal data, to object to or restrict certain processing, and to withdraw consent at any time.',
    'To exercise a right, write to $kEmail. We reply within 30 days. You also have the right to complain to your local data protection authority.',
  ]),
  Section('9. Security', [
    'We use encryption in transit (HTTPS), restricted access to personal data and regular reviews. No system is perfectly secure, so we also encourage strong, unique passwords and caution with unsolicited messages.',
  ]),
  Section('10. International transfers', [
    'If data is transferred outside your country, a real store would rely on lawful safeguards such as standard contractual clauses.',
  ]),
  Section('11. Children', [
    'Our shop is not directed to children under 16 and we do not knowingly collect their data.',
  ]),
  Section('12. Changes to this policy', [
    'We may update this policy from time to time. The "last updated" date at the top shows the current version.',
  ]),
  Section('13. Contact', [
    '$kCompanyEn, $kAddressEn. Email: $kEmail. Phone: $kPhone.',
  ]),
];

const privacyAr = <Section>[
  Section('١. من نحن', [
    'خيط ("نحن") أتيليه أزياء وهمي أُنشئ كمشروع لعرض الأعمال البرمجية. هذا الموقع للعرض التوضيحي فقط: لا تُباع منتجات حقيقية ولا تُنفّذ طلبات حقيقية ولا تتم أي مدفوعات حقيقية.',
    'تشرح هذه السياسة، كما يفعل أي متجر حقيقي، ما هي البيانات الشخصية التي يجمعها متجر كهذا وكيف يجب حمايتها. للتواصل: $kEmail.',
  ]),
  Section('٢. المعلومات التي نجمعها', [
    'بيانات التواصل مثل اسمك وبريدك الإلكتروني ورقم هاتفك وعنوان التوصيل عند إجراء طلب أو مراسلتنا.',
    'تفاصيل الطلب مثل القطع المشتراة والمقاسات والألوان وإجمالي الطلب وخيارات التوصيل.',
    'بيانات الدفع مثل نوع البطاقة وآخر أربعة أرقام. في المتجر الحقيقي يتم إدخال رقم البطاقة كاملاً وتاريخ الانتهاء ورمز الأمان لدى مزوّد دفع متوافق مع معيار PCI-DSS ولا تُخزَّن على خوادمنا أبداً.',
    'بيانات تقنية مثل نوع الجهاز والمتصفح وتفضيل اللغة والصفحات التي تزورها عبر ملفات تعريف الارتباط وتقنيات مشابهة.',
  ]),
  Section('٣. كيف نستخدم معلوماتك', [
    'لمعالجة طلباتك وتوصيلها وإرسال التأكيدات والتعامل مع الإرجاع.',
    'لتقديم الدعم والرد على رسائلك.',
    'لمنع الاحتيال وحماية الموقع، بما في ذلك التحقق من البطاقة (3-D Secure).',
    'لتحسين الموقع، مثلاً بمعرفة المنتجات والصفحات الأكثر فائدة.',
    'لإرسال رسائل تسويقية فقط إذا وافقت على ذلك، ويمكنك إلغاء الاشتراك في أي وقت.',
  ]),
  Section('٤. حول هذا العرض التجريبي', [
    'في هذا العرض، كل ما تكتبه في نموذج الدفع يبقى داخل تبويب المتصفح فقط. لا يُرسل شيء إلى أي خادم ولا يُخزَّن شيء، ونموذج البطاقة يتحقق من صيغة الرقم محلياً فقط. الرجاء عدم إدخال رقم بطاقة حقيقي واستخدم البطاقة التجريبية الظاهرة في صفحة الدفع.',
    'اختيارك للغة ومحتويات السلة محفوظة في الذاكرة فقط وتختفي عند إغلاق الصفحة أو تحديثها.',
  ]),
  Section('٥. ملفات تعريف الارتباط', [
    'المتجر الحقيقي يستخدم ملفات أساسية (السلة والأمان) وملفات تفضيلات (اللغة) وملفات اختيارية للتحليلات أو التسويق. لا تُفعَّل الملفات غير الأساسية إلا بعد موافقتك ويمكنك تغيير اختيارك في أي وقت. هذا العرض لا يضع أي ملفات تتبّع.',
  ]),
  Section('٦. مشاركة معلوماتك', [
    'لا نبيع البيانات الشخصية أبداً. المتجر الحقيقي يشاركها فقط مع مزوّدي الخدمات الذين يساعدون في التشغيل: معالجو الدفع وشركات الشحن ومزوّدو البريد والاستضافة وخدمات منع الاحتيال، ولا يجوز لهم استخدامها إلا لتقديم خدمتهم لنا وبموجب عقد.',
    'قد نفصح عن البيانات حيث يتطلب القانون ذلك أو لحماية الحقوق والسلامة والممتلكات.',
  ]),
  Section('٧. مدة الاحتفاظ', [
    'نحتفظ بسجلات الطلبات والفواتير للمدة التي تفرضها قوانين الضرائب والمحاسبة (عادةً من ٦ إلى ١٠ سنوات). رسائل الدعم حتى ٢٤ شهراً. وتفضيلات التسويق حتى تسحب موافقتك.',
  ]),
  Section('٨. حقوقك', [
    'بحسب مكان إقامتك (مثل اللائحة العامة لحماية البيانات GDPR أو قانون CCPA) يمكنك طلب الاطلاع على بياناتك الشخصية أو تصحيحها أو حذفها أو تصديرها، والاعتراض على معالجة معينة أو تقييدها، وسحب موافقتك في أي وقت.',
    'لممارسة حق ما راسلنا على $kEmail وسنرد خلال ٣٠ يوماً. ولك الحق أيضاً في تقديم شكوى إلى هيئة حماية البيانات المحلية.',
  ]),
  Section('٩. الأمان', [
    'نستخدم التشفير أثناء النقل (HTTPS) وصلاحيات وصول محدودة ومراجعات دورية. لا يوجد نظام آمن بالكامل لذلك ننصح أيضاً بكلمات مرور قوية وفريدة والحذر من الرسائل غير المطلوبة.',
  ]),
  Section('١٠. النقل الدولي', [
    'إذا نُقلت البيانات خارج بلدك فسيعتمد المتجر الحقيقي على ضمانات قانونية مثل البنود التعاقدية القياسية.',
  ]),
  Section('١١. الأطفال', [
    'متجرنا غير موجّه للأطفال دون ١٦ عاماً ولا نجمع بياناتهم عن علم.',
  ]),
  Section('١٢. التعديلات على هذه السياسة', [
    'قد نحدّث هذه السياسة من وقت لآخر، ويظهر تاريخ "آخر تحديث" في أعلى الصفحة.',
  ]),
  Section('١٣. التواصل', [
    '$kCompanyAr، $kAddressAr. البريد: $kEmail. الهاتف: $kPhone.',
  ]),
];

// -------------------------------------------------------------- TERMS
const termsEn = <Section>[
  Section('1. Demonstration notice', [
    'Khayt is a fictional store built for a portfolio. These terms describe how a real shop of this kind would operate. No contract of sale is formed on this site, no goods are shipped and no money is taken.',
  ]),
  Section('2. Using the website', [
    'You may browse and use the site for lawful personal purposes. You agree not to misuse it, attempt to gain unauthorised access, scrape it at scale, or interfere with its operation.',
  ]),
  Section('3. Products and pricing', [
    'We try to display colours, sizes and descriptions accurately, but screens vary. The 3D viewer is an illustration of the garment. All prices are shown in US dollars and include no taxes unless stated; estimated tax is added at checkout.',
    'We may correct pricing or description errors and cancel affected orders with a full refund.',
  ]),
  Section('4. Orders and payment', [
    'An order is an offer to buy. A contract is formed when we confirm dispatch. We accept Visa and Mastercard. Card payments may require 3-D Secure verification. A promotional code can be used once per order and cannot be combined with other offers.',
  ]),
  Section('5. Delivery and returns', [
    'Delivery times are estimates. Our Shipping & Returns page explains costs, timing, and the 30-day free returns policy, and forms part of these terms.',
  ]),
  Section('6. Intellectual property', [
    'The Khayt name, logo, designs, text and software are the property of their owners and may not be copied without permission. Product photographs are provided by Unsplash contributors under the Unsplash licence.',
  ]),
  Section('7. Limitation of liability', [
    'To the extent permitted by law, we are not liable for indirect or consequential loss arising from use of the site. Nothing in these terms limits liability that cannot be limited by law, including for death or personal injury caused by negligence, or for fraud.',
  ]),
  Section('8. Consumer rights', [
    'These terms do not affect your statutory rights as a consumer, including any right to cancel and to receive goods that match their description.',
  ]),
  Section('9. Changes and governing law', [
    'We may update these terms from time to time. A real store would state its governing law and courts here; this fictional store names none.',
  ]),
  Section('10. Contact', [
    '$kCompanyEn, $kAddressEn. Email: $kEmail.',
  ]),
];

const termsAr = <Section>[
  Section('١. تنبيه العرض التجريبي', [
    'خيط متجر وهمي صُنع لعرض الأعمال. تصف هذه الشروط كيف يعمل متجر حقيقي من هذا النوع. لا يتشكّل أي عقد بيع على هذا الموقع ولا تُشحن بضائع ولا تؤخذ أموال.',
  ]),
  Section('٢. استخدام الموقع', [
    'يمكنك تصفح الموقع واستخدامه لأغراض شخصية مشروعة. وتوافق على عدم إساءة استخدامه أو محاولة الوصول غير المصرح به أو سحب محتواه على نطاق واسع أو التدخل في عمله.',
  ]),
  Section('٣. المنتجات والأسعار', [
    'نحاول عرض الألوان والمقاسات والأوصاف بدقة لكن الشاشات تختلف. العارض الثلاثي الأبعاد توضيح للقطعة. جميع الأسعار بالدولار الأمريكي ولا تشمل الضرائب ما لم يُذكر، وتُضاف ضريبة تقديرية عند الدفع.',
    'قد نصحّح أخطاء الأسعار أو الأوصاف ونلغي الطلبات المتأثرة مع استرداد كامل.',
  ]),
  Section('٤. الطلبات والدفع', [
    'الطلب هو عرض للشراء، ويتشكّل العقد عندما نؤكد الشحن. نقبل فيزا وماستركارد، وقد تتطلب مدفوعات البطاقة التحقق عبر 3-D Secure. يمكن استخدام رمز الخصم مرة واحدة لكل طلب ولا يُجمع مع عروض أخرى.',
  ]),
  Section('٥. التوصيل والإرجاع', [
    'مواعيد التوصيل تقديرية. توضّح صفحة الشحن والإرجاع التكاليف والمواعيد وسياسة الإرجاع المجاني خلال ٣٠ يوماً، وهي جزء من هذه الشروط.',
  ]),
  Section('٦. الملكية الفكرية', [
    'اسم خيط وشعاره وتصاميمه ونصوصه وبرمجياته ملك لأصحابها ولا يجوز نسخها دون إذن. صور المنتجات من مساهمين على Unsplash بموجب رخصة Unsplash.',
  ]),
  Section('٧. حدود المسؤولية', [
    'بالقدر الذي يسمح به القانون، لا نتحمل مسؤولية الخسائر غير المباشرة أو التبعية الناتجة عن استخدام الموقع. ولا يحدّ أي شيء هنا من مسؤولية لا يجوز تحديدها قانوناً، ومنها الوفاة أو الإصابة الشخصية الناتجة عن الإهمال أو الاحتيال.',
  ]),
  Section('٨. حقوق المستهلك', [
    'لا تؤثر هذه الشروط على حقوقك القانونية كمستهلك، بما في ذلك حق الإلغاء واستلام بضائع تطابق وصفها.',
  ]),
  Section('٩. التعديلات والقانون الواجب التطبيق', [
    'قد نحدّث هذه الشروط من وقت لآخر. المتجر الحقيقي يذكر هنا القانون والمحاكم المختصة، أما هذا المتجر الوهمي فلا يحدد شيئاً.',
  ]),
  Section('١٠. التواصل', [
    '$kCompanyAr، $kAddressAr. البريد: $kEmail.',
  ]),
];

// ----------------------------------------------------------- SHIPPING
const shippingEn = <Section>[
  Section('Delivery options', [
    'Standard: 3 to 6 business days. Free on orders over \$120, otherwise \$9.',
    'Express: 1 to 2 business days for a flat \$14.',
    'Orders placed before 14:00 (Mon to Fri) leave our studio the same day. Delivery times start from dispatch.',
  ]),
  Section('Where we ship', [
    'The United States, United Kingdom, Germany, Turkey, the United Arab Emirates, Saudi Arabia, Qatar, Jordan, Egypt and Canada, with more countries coming soon.',
    'International orders may be subject to import duties and taxes charged by the destination country. These are the recipient\'s responsibility.',
  ]),
  Section('Tracking', [
    'As soon as your order ships you receive an email with a tracking link.',
  ]),
  Section('Free 30-day returns', [
    'Not right? Return any unworn item with its tags within 30 days of delivery and we refund the full price to your original payment method within 5 to 10 business days of receiving it.',
    'Start a return by writing to $kEmail with your order number. We email a prepaid label.',
  ]),
  Section('Exchanges', [
    'Need a different size or colour? Return the original item and place a new order. It is the fastest way to make sure your size is in stock.',
  ]),
  Section('Damaged or incorrect items', [
    'If something arrives damaged or is not what you ordered, contact us within 14 days with a photo and we will replace it or refund you, including shipping.',
  ]),
  Section('Final sale items', [
    'Items marked as final sale, gift cards and hygiene products cannot be returned unless faulty.',
  ]),
];

const shippingAr = <Section>[
  Section('خيارات التوصيل', [
    'عادي: من ٣ إلى ٦ أيام عمل. مجاني للطلبات فوق ١٢٠\$ وإلا ٩\$.',
    'سريع: من ١ إلى ٢ يوم عمل بسعر ثابت ١٤\$.',
    'الطلبات قبل الساعة ١٤:٠٠ (من الإثنين إلى الجمعة) تغادر الأتيليه في اليوم نفسه، وتبدأ مدة التوصيل من لحظة الشحن.',
  ]),
  Section('إلى أين نشحن', [
    'الولايات المتحدة والمملكة المتحدة وألمانيا وتركيا والإمارات والسعودية وقطر والأردن ومصر وكندا، ودول أخرى قريباً.',
    'قد تخضع الطلبات الدولية لرسوم وضرائب استيراد تفرضها دولة الوجهة وهي على مسؤولية المستلم.',
  ]),
  Section('التتبّع', [
    'بمجرد شحن طلبك يصلك بريد فيه رابط التتبّع.',
  ]),
  Section('إرجاع مجاني خلال ٣٠ يوماً', [
    'لم تعجبك القطعة؟ أعد أي قطعة غير ملبوسة ببطاقتها خلال ٣٠ يوماً من التسليم ونعيد لك السعر كاملاً إلى وسيلة الدفع الأصلية خلال ٥ إلى ١٠ أيام عمل من استلامها.',
    'لبدء الإرجاع راسلنا على $kEmail مع رقم الطلب وسنرسل لك ملصق شحن مدفوع مسبقاً.',
  ]),
  Section('الاستبدال', [
    'تحتاج مقاساً أو لوناً آخر؟ أعد القطعة الأصلية وقدّم طلباً جديداً، فهي أسرع طريقة لضمان توفر مقاسك.',
  ]),
  Section('قطع تالفة أو خاطئة', [
    'إذا وصلتك قطعة تالفة أو غير التي طلبتها فتواصل معنا خلال ١٤ يوماً مع صورة وسنستبدلها أو نعيد لك المبلغ مع الشحن.',
  ]),
  Section('قطع التصفية النهائية', [
    'لا يمكن إرجاع القطع المعلّمة تصفية نهائية وبطاقات الهدايا ومنتجات النظافة إلا إذا كانت معيبة.',
  ]),
];

// ---------------------------------------------------------------- FAQ
class Qa {
  final String q;
  final String a;
  const Qa(this.q, this.a);
}

const faqEn = <Qa>[
  Qa('Is Khayt a real store?', 'No. Khayt is a fictional brand created for a portfolio project. Products, prices, reviews and orders are imaginary, and no payment is ever taken.'),
  Qa('How does the 3D viewer work?', 'The knitwear pieces are modelled in 3D right in your browser. Drag to rotate, tap a swatch to change colour, and notice that the whole store takes the colour you pick.'),
  Qa('Which payment methods do you accept?', 'Visa and Mastercard. At checkout the card form detects the brand as you type and runs a simulated 3-D Secure step. Use the test card 4242 4242 4242 4242 with any future date and any CVC.'),
  Qa('Is my card data safe?', 'In this demo your card details never leave the page. A live store would hand them directly to a PCI-compliant payment provider and never store them.'),
  Qa('How long does delivery take?', 'Standard delivery takes 3 to 6 business days and express 1 to 2 business days. Orders over \$120 ship free.'),
  Qa('What is your returns policy?', 'Free returns within 30 days of delivery for unworn items with their tags.'),
  Qa('How do I choose my size?', 'Each product page lists its sizes. Knits run true to size; the Oversized Rib Knit is cut roomy, so take your usual size for the intended look or one size down for a closer fit.'),
  Qa('Is there a promo code?', 'Yes. Try KHAYT10 in your bag for 10% off.'),
  Qa('Can I change or cancel an order?', 'Write to us within one hour of ordering and we will do our best to change or cancel it before it is packed.'),
];

const faqAr = <Qa>[
  Qa('هل خيط متجر حقيقي؟', 'لا. خيط علامة وهمية صُنعت لمشروع عرض أعمال. المنتجات والأسعار والتقييمات والطلبات خيالية ولا تؤخذ أي مدفوعات.'),
  Qa('كيف يعمل العارض الثلاثي الأبعاد؟', 'قطع التريكو مصمّمة بالـ 3D داخل متصفحك مباشرة. اسحب للتدوير واضغط على لون لتغييره، ولاحظ أن المتجر كله يأخذ اللون الذي تختاره.'),
  Qa('ما طرق الدفع المقبولة؟', 'فيزا وماستركارد. نموذج البطاقة يتعرف على نوعها أثناء الكتابة وينفّذ خطوة 3-D Secure محاكاة. استخدم البطاقة التجريبية 4242 4242 4242 4242 مع أي تاريخ مستقبلي وأي CVC.'),
  Qa('هل بيانات بطاقتي آمنة؟', 'في هذا العرض لا تغادر بيانات بطاقتك الصفحة. المتجر الحقيقي يمررها مباشرة لمزوّد دفع متوافق مع PCI ولا يخزّنها أبداً.'),
  Qa('كم يستغرق التوصيل؟', 'التوصيل العادي من ٣ إلى ٦ أيام عمل والسريع من ١ إلى ٢ يوم عمل. الطلبات فوق ١٢٠\$ شحنها مجاني.'),
  Qa('ما سياسة الإرجاع؟', 'إرجاع مجاني خلال ٣٠ يوماً من التسليم للقطع غير الملبوسة وببطاقاتها.'),
  Qa('كيف أختار مقاسي؟', 'تعرض كل صفحة منتج مقاساتها. التريكو بمقاسه الطبيعي، أما الكنزة الواسعة المضلّعة فقصّتها واسعة، فخذ مقاسك المعتاد للإطلالة المقصودة أو مقاساً أصغر لقصّة أقرب.'),
  Qa('هل يوجد رمز خصم؟', 'نعم. جرّب KHAYT10 في سلتك للحصول على خصم ١٠٪.'),
  Qa('هل يمكنني تعديل الطلب أو إلغاؤه؟', 'راسلنا خلال ساعة من الطلب وسنبذل جهدنا لتعديله أو إلغائه قبل التغليف.'),
];

// -------------------------------------------------------------- ABOUT
const aboutStoryEn = [
  'Khayt means "thread" in Arabic, and everything we imagine starts with one. A single honest thread, spun carefully, can become a sweater that lasts a decade.',
  'We are a fictional atelier, so we can say what we wish a real brand would: make fewer things, make them well, and tell people exactly what they are made of.',
  'This store was built as a portfolio piece in Flutter: a full cart, card checkout, bilingual layout (English and Arabic, with real right-to-left support) and a knitwear viewer drawn from scratch in three.js with no 3D model files at all.',
];
const aboutStoryAr = [
  'خيط تعني "الخيط"، وكل ما نتخيله يبدأ بخيط واحد. خيط صادق واحد يُغزل بعناية يمكن أن يصير كنزة تدوم عشر سنوات.',
  'نحن أتيليه وهمي، لذلك نقول ما نتمنى أن تقوله علامة حقيقية: اصنع أقل، اصنعه جيداً، وأخبر الناس بالضبط مما صُنع.',
  'بُني هذا المتجر كمشروع لعرض الأعمال بـ Flutter: سلة كاملة ودفع ببطاقة وواجهة ثنائية اللغة (إنجليزي وعربي مع دعم حقيقي لاتجاه اليمين لليسار) وعارض تريكو مرسوم من الصفر بـ three.js بدون أي ملفات موديلات ثلاثية الأبعاد.',
];

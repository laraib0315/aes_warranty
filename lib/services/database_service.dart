import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/brand_model.dart';
import '../models/product_model.dart';
import '../models/customer_model.dart';
import '../models/warranty_model.dart';
import '../models/payment_model.dart';
import '../models/draft_model.dart';
import '../models/qr_batch_model.dart';
import '../models/activity_log_model.dart';
import '../models/notification_model.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  DatabaseService._();

  // Box names
  static const String usersBox = 'users';
  static const String categoriesBox = 'categories';
  static const String brandsBox = 'brands';
  static const String productsBox = 'products';
  static const String customersBox = 'customers';
  static const String warrantiesBox = 'warranties';
  static const String paymentsBox = 'payments';
  static const String draftsBox = 'drafts';
  static const String qrBatchesBox = 'qrBatches';
  static const String activityLogBoxName = 'activityLog';
  static const String notificationsBox = 'notifications';

  // Box references
  late Box<UserModel> userBox;
  late Box<CategoryModel> categoryBox;
  late Box<BrandModel> brandBox;
  late Box<ProductModel> productBox;
  late Box<CustomerModel> customerBox;
  late Box<WarrantyModel> warrantyBox;
  late Box<PaymentModel> paymentBox;
  late Box<DraftModel> draftBox;
  late Box<QrBatchModel> qrBatchBox;
  late Box<ActivityLogModel> activityLogBox;
  late Box<NotificationModel> notificationBox;

  Future<void> init() async {
    // Web ke liye alag initialization, mobile ke liye alag
    if (kIsWeb) {
      // Web par path_provider ki zaroorat nahi – Hive IndexedDB use karega
      await Hive
          .initFlutter(); // Web par ye bhi kaam karega, ya Hive.init('') bhi chalega
    } else {
      // Mobile/Desktop ke liye documents directory
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

    // Register adapters (saare models ke adapters)
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(BrandModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CustomerModelAdapter());
    Hive.registerAdapter(WarrantyStatusAdapter());
    Hive.registerAdapter(WarrantyModelAdapter());
    Hive.registerAdapter(PaymentModelAdapter());
    Hive.registerAdapter(DraftTypeAdapter());
    Hive.registerAdapter(DraftModelAdapter());
    Hive.registerAdapter(QrBatchModelAdapter());
    Hive.registerAdapter(ActivityLogModelAdapter());
    Hive.registerAdapter(NotificationModelAdapter());

    // Open boxes
    userBox = await Hive.openBox<UserModel>(usersBox);
    categoryBox = await Hive.openBox<CategoryModel>(categoriesBox);
    brandBox = await Hive.openBox<BrandModel>(brandsBox);
    productBox = await Hive.openBox<ProductModel>(productsBox);
    customerBox = await Hive.openBox<CustomerModel>(customersBox);
    warrantyBox = await Hive.openBox<WarrantyModel>(warrantiesBox);
    paymentBox = await Hive.openBox<PaymentModel>(paymentsBox);
    draftBox = await Hive.openBox<DraftModel>(draftsBox);
    qrBatchBox = await Hive.openBox<QrBatchModel>(qrBatchesBox);
    activityLogBox = await Hive.openBox<ActivityLogModel>(activityLogBoxName);
    notificationBox = await Hive.openBox<NotificationModel>(notificationsBox);
  }
}

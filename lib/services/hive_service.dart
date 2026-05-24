import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/material_rate_model.dart';

// Box names — think of these as the names of the "filing cabinets" on the phone
const String kUserBox = 'users';
const String kProjectBox = 'projects';
const String kRatesBox = 'material_rates';
const String kSettingsBox = 'settings';

class HiveService {
  /// Call this once when the app starts to open all storage boxes.
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register the type adapters (teach Hive how to read/write each model)
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ProjectModelAdapter());
    Hive.registerAdapter(MaterialRateModelAdapter());

    // Open all boxes (creates the files on the phone if they don't exist)
    await Hive.openBox<UserModel>(kUserBox);
    await Hive.openBox<ProjectModel>(kProjectBox);
    await Hive.openBox<MaterialRateModel>(kRatesBox);
    await Hive.openBox(kSettingsBox);
  }

  static Box<UserModel> get userBox => Hive.box<UserModel>(kUserBox);
  static Box<ProjectModel> get projectBox => Hive.box<ProjectModel>(kProjectBox);
  static Box<MaterialRateModel> get ratesBox => Hive.box<MaterialRateModel>(kRatesBox);
  static Box get settingsBox => Hive.box(kSettingsBox);
}

import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String passwordHash; // we never store the real password, only a hash

  @HiveField(5)
  String company;

  @HiveField(6)
  String licenseNumber;

  @HiveField(7)
  String role; // e.g. Civil Engineer, Contractor

  @HiveField(8)
  String location;

  @HiveField(9)
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.passwordHash,
    this.company = '',
    this.licenseNumber = '',
    this.role = 'Civil Engineer',
    this.location = '',
    required this.createdAt,
  });
}

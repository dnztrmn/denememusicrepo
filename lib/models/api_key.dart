import 'package:hive/hive.dart';

part 'api_key.g.dart';

@HiveType(typeId: 0)
class APIKey extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  bool isActive;

  @HiveField(3)
  int quotaUsed;

  @HiveField(4)
  DateTime lastUsed;

  @HiveField(5)
  int dailyQuotaLimit;

  APIKey({
    required this.id,
    required this.name,
    this.isActive = true,
    this.quotaUsed = 0,
    DateTime? lastUsed,
    this.dailyQuotaLimit = 10000,
  }) : this.lastUsed = lastUsed ?? DateTime.now();
}

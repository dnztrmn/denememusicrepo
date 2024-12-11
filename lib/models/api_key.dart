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

  APIKey({
    required this.id,
    required this.name,
    this.isActive = true,
    this.quotaUsed = 0,
  });
}

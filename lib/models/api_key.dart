import 'package:hive/hive.dart';

part 'api_key.g.dart';

@HiveType(typeId: 0)
class APIKey {
  @HiveField(0)
  final String key;

  @HiveField(1)
  final String name;

  @HiveField(2)
  int quotaUsed;

  @HiveField(3)
  DateTime lastUsed;

  @HiveField(4)
  bool isActive;

  @HiveField(5)
  int dailyQuotaLimit;

  APIKey({
    required this.key,
    required this.name,
    this.quotaUsed = 0,
    DateTime? lastUsed,
    this.isActive = true,
    this.dailyQuotaLimit = 10000,
  }) : this.lastUsed = lastUsed ?? DateTime.now();

  bool get isQuotaExceeded => quotaUsed >= dailyQuotaLimit;

  void resetQuota() {
    if (DateTime.now().difference(lastUsed).inDays >= 1) {
      quotaUsed = 0;
      lastUsed = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'quotaUsed': quotaUsed,
      'lastUsed': lastUsed.toIso8601String(),
      'isActive': isActive,
      'dailyQuotaLimit': dailyQuotaLimit,
    };
  }

  factory APIKey.fromJson(Map<String, dynamic> json) {
    return APIKey(
      key: json['key'],
      name: json['name'],
      quotaUsed: json['quotaUsed'] ?? 0,
      lastUsed:
          json['lastUsed'] != null ? DateTime.parse(json['lastUsed']) : null,
      isActive: json['isActive'] ?? true,
      dailyQuotaLimit: json['dailyQuotaLimit'] ?? 10000,
    );
  }
}

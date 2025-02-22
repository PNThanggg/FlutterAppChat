import 'package:chat_sdk_core/chat_sdk_core.dart';

class VMyOrderInfo {
  final String lastSeenAt;
  final VOrderSettings orderSettings;

  const VMyOrderInfo({
    required this.lastSeenAt,
    required this.orderSettings,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMyOrderInfo &&
          runtimeType == other.runtimeType &&
          lastSeenAt == other.lastSeenAt &&
          orderSettings == other.orderSettings);

  @override
  int get hashCode => lastSeenAt.hashCode ^ orderSettings.hashCode;

  @override
  String toString() {
    return 'VMyOrderInfo{ lastSeenAt: $lastSeenAt, orderSettings: $orderSettings,}';
  }

  VMyOrderInfo copyWith({
    String? lastSeenAt,
    VOrderSettings? orderSettings,
  }) {
    return VMyOrderInfo(
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      orderSettings: orderSettings ?? this.orderSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastSeenAt': lastSeenAt,
      'orderSettings': orderSettings.toMap(),
    };
  }

  factory VMyOrderInfo.fromMap(Map<String, dynamic> map) {
    return VMyOrderInfo(
      lastSeenAt: map['lastSeenAt'] as String,
      orderSettings: VOrderSettings.fromMap(map['orderSettings'] as Map<String, dynamic>),
    );
  }
}


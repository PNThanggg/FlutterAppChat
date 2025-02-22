class VOrderSettings {
  final String? orderTitle;
  final String? orderImage;
  final bool isClosed;
  final String orderId;
  final Map<String, dynamic>? pinData;

  const VOrderSettings({
    this.orderTitle,
    this.orderImage,
    required this.isClosed,
    required this.orderId,
    this.pinData,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VOrderSettings &&
          runtimeType == other.runtimeType &&
          orderTitle == other.orderTitle &&
          orderImage == other.orderImage &&
          isClosed == other.isClosed &&
          orderId == other.orderId &&
          pinData == other.pinData);

  @override
  int get hashCode =>
      orderTitle.hashCode ^ orderImage.hashCode ^ isClosed.hashCode ^ orderId.hashCode ^ pinData.hashCode;

  @override
  String toString() {
    return 'VOrderSettings{ orderTitle: $orderTitle, orderImage: $orderImage, isClosed: $isClosed, orderId: $orderId, pinData: $pinData,}';
  }

  VOrderSettings copyWith({
    String? orderTitle,
    String? orderImage,
    bool? isClosed,
    String? orderId,
    Map<String, dynamic>? pinData,
  }) {
    return VOrderSettings(
      orderTitle: orderTitle ?? this.orderTitle,
      orderImage: orderImage ?? this.orderImage,
      isClosed: isClosed ?? this.isClosed,
      orderId: orderId ?? this.orderId,
      pinData: pinData ?? this.pinData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderTitle': orderTitle,
      'orderImage': orderImage,
      'isClosed': isClosed,
      'orderId': orderId,
      'pinData': pinData,
    };
  }

  factory VOrderSettings.fromMap(Map<String, dynamic> map) {
    return VOrderSettings(
      orderTitle: map['orderTitle'] as String?,
      orderImage: map['orderImage'] as String?,
      isClosed: map['isClosed'] as bool,
      orderId: map['orderId'] as String,
      pinData: map['pinData'] as Map<String, dynamic>?,
    );
  }
}

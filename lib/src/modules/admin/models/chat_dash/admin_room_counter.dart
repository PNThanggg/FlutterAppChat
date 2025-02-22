class AdminRoomCounter {
  final int single;
  final int order;
  final int group;
  final int broadcast;

  const AdminRoomCounter({
    required this.single,
    required this.order,
    required this.group,
    required this.broadcast,
  });

  AdminRoomCounter.empty()
      : single = 0,
        order = 0,
        group = 0,
        broadcast = 0;

  @override
  String toString() {
    return 'AdminRoomCounter{ single: $single, order: $order, group: $group, broadcast: $broadcast,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'single': single,
      'order': order,
      'group': group,
      'broadcast': broadcast,
    };
  }

  factory AdminRoomCounter.fromMap(Map<String, dynamic> map) {
    return AdminRoomCounter(
      single: map['single'] as int,
      order: map['order'] as int,
      group: map['group'] as int,
      broadcast: map['broadcast'] as int,
    );
  }
}

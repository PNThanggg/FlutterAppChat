class RoomCounter {
  final int single;
  final int order;
  final int group;
  final int broadcast;
  final int total;

  RoomCounter({
    required this.single,
    required this.order,
    required this.group,
    required this.broadcast,
    required this.total,
  });

  RoomCounter.empty()
      : single = 0,
        order = 0,
        group = 0,
        total = 0,
        broadcast = 0;

  Map<String, dynamic> toMap() {
    return {
      'single': single,
      'order': order,
      'group': group,
      'total': total,
      'broadcast': broadcast,
    };
  }

  factory RoomCounter.fromMap(Map<String, dynamic> map) {
    return RoomCounter(
      single: map['single'],
      order: map['order'],
      total: map['total'],
      group: map['group'],
      broadcast: map['broadcast'],
    );
  }
}

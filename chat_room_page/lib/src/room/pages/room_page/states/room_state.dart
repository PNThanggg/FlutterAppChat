import 'package:chat_sdk_core/chat_sdk_core.dart';

class RoomState {
  final VPaginationModel<VRoom> list;

  RoomState({
    required this.list,
  });

  factory RoomState.empty() {
    return RoomState(
      list: VPaginationModel<VRoom>(
        data: <VRoom>[],
        limit: 20,
        page: 2,
        nextPage: null,
      ),
    );
  }

  @override
  String toString() {
    return 'RoomState{list: $list}';
  }

  RoomState copyWith({
    VPaginationModel<VRoom>? list,
  }) {
    return RoomState(
      list: list ?? this.list,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RoomState && runtimeType == other.runtimeType && list == other.list;

  @override
  int get hashCode => list.hashCode;
}

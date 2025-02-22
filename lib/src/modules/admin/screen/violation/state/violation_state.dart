import '../../../admin.dart';

class ViolationState {
  final List<ViolationModel> listViolation;

  ViolationState({
    required this.listViolation,
  });

  ViolationState.empty() : listViolation = [];

  @override
  String toString() {
    return 'ViolationState{listViolation: ${listViolation.toString()}}';
  }

  ViolationState copyWith({
    List<ViolationModel>? list,
  }) {
    return ViolationState(
      listViolation: list ?? listViolation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ViolationState && runtimeType == other.runtimeType && listViolation == other.listViolation;

  @override
  int get hashCode => listViolation.hashCode;
}

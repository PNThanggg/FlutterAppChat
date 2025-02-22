class AppState {
  final bool isAdmin;

  AppState({
    required this.isAdmin,
  });

  @override
  String toString() {
    return 'AppStatus{isAdmin: $isAdmin}';
  }

  AppState copyWith({
    bool? isAdmin,
  }) {
    return AppState(
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppState && runtimeType == other.runtimeType && isAdmin == other.isAdmin;

  @override
  int get hashCode => isAdmin.hashCode;
}

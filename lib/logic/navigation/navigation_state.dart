class NavigationState {
  final int currentPageIndex;
  final bool isScanTabActive;

  NavigationState({
    required this.currentPageIndex,
    required this.isScanTabActive,
  });

  NavigationState copyWith({
    int? currentPageIndex,
    bool? isScanTabActive,
  }) {
    return NavigationState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isScanTabActive: isScanTabActive ?? this.isScanTabActive,
    );
  }
}

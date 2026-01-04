import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(currentPageIndex: 0, isScanTabActive: false)) {
    on<SelectPageEvent>((event, emit) {
      final isScanTab = event.index == 2; // Assuming Scan tab is index 2
      emit(
        state.copyWith(
          currentPageIndex: event.index,
          isScanTabActive: isScanTab,
        ),
      );
    });
  }
}
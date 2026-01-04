import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/data/repositories/user_repository.dart';
import 'package:flutter_firebase_template/logic/user/user_event.dart';
import 'package:flutter_firebase_template/logic/user/user_state.dart';
import 'package:flutter_firebase_template/data/models/user_model.dart';

/// Bloc for managing the current user's data and state.
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserModel? _cachedUser;
  String? _lastFetchUserId;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUserRequested>((event, emit) async {
      // If we already have cached data for this user, use it instead of fetching
      if (_cachedUser != null && _lastFetchUserId == event.userId) {
        emit(UserLoaded(_cachedUser!));
        return;
      }

      // Otherwise, fetch the data
      emit(UserLoading());
      try {
        final user = await userRepository.fetchUserData(event.userId);
        _cachedUser = user;
        _lastFetchUserId = event.userId;
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserFailure(e.toString()));
      }
    });

    on<RefreshUserRequested>((event, emit) async {
      // Force refresh regardless of cache
      emit(UserLoading());
      try {
        final user = await userRepository.fetchUserData(event.userId);
        _cachedUser = user;
        _lastFetchUserId = event.userId;
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserFailure(e.toString()));
      }
    });

    on<ClearUserCache>((event, emit) async {
      _cachedUser = null;
      _lastFetchUserId = null;
      emit(UserInitial());
    });
  }
}


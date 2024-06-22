import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../services/guard_service.dart';

part './guard_event.dart';
part './guard_state.dart';

class GuardBloc extends Bloc<GuardEvent, GuardState> {
  final GuardService guardService;

  GuardBloc({required this.guardService}) : super(GuardInitial()) {
    on<FetchGuards>(_onFetchGuards);
  }

  Future<void> _onFetchGuards(
      FetchGuards event, Emitter<GuardState> emit) async {
    emit(GuardLoading());
    try {
      final guards = await guardService.getGuardList();
      emit(GuardListLoaded(guards: guards));
    } catch (e) {
      emit(GuardError(message: e.toString()));
    }
  }
}

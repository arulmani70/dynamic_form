import 'package:dynamic_form/src/common/models/dynamic_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'df_renderer_event.dart';
part 'df_renderer_state.dart';

class DFRendererBloc extends Bloc<DFRendererEvent, DFRendererState> {
  DFRendererBloc() : super(DFRendererState.initial) {
    on<DFRendererInitialized>(_onInit);
    on<DFRendererFieldChanged>(_onChanged);
    on<DFRendererSubmitted>(_onSubmit);
  }

  final _log = Logger();

  Future<void> _onInit(
    DFRendererInitialized event,
    Emitter<DFRendererState> emit,
  ) async {
    emit(state.copyWith(status: () => DFRendererStatus.loading));
    try {
      final fields = event.jsonSpec
          .map((e) => DynamicField.fromJson(e))
          .toList();
      emit(
        state.copyWith(
          status: () => DFRendererStatus.success,
          fields: () => fields,
        ),
      );
    } catch (e, st) {
      _log.e('Parse failed', error: e, stackTrace: st);
      emit(
        state.copyWith(
          status: () => DFRendererStatus.failure,
          message: () => 'Invalid form spec',
        ),
      );
    }
  }

  void _onChanged(DFRendererFieldChanged event, Emitter<DFRendererState> emit) {
    emit(state.copyWith(values: () => event.values, submitted: () => false));
  }

  void _onSubmit(DFRendererSubmitted event, Emitter<DFRendererState> emit) {
    _log.i('Form submitted -> ${event.values}');
    emit(state.copyWith(values: () => event.values, submitted: () => true));
  }
}

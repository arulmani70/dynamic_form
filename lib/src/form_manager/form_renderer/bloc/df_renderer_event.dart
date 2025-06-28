part of 'df_renderer_bloc.dart';

abstract class DFRendererEvent extends Equatable {
  const DFRendererEvent();
  @override
  List<Object?> get props => [];
}

class DFRendererInitialized extends DFRendererEvent {
  final List<Map<String, dynamic>> jsonSpec;
  const DFRendererInitialized(this.jsonSpec);
  @override
  List<Object?> get props => [jsonSpec];
}

class DFRendererFieldChanged extends DFRendererEvent {
  final Map<String, dynamic> values;
  const DFRendererFieldChanged(this.values);
  @override
  List<Object?> get props => [values];
}

class DFRendererSubmitted extends DFRendererEvent {
  final Map<String, dynamic> values;
  const DFRendererSubmitted(this.values);
  @override
  List<Object?> get props => [values];
}

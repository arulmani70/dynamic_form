part of 'df_renderer_bloc.dart';

enum DFRendererStatus { initial, loading, success, failure }

class DFRendererState extends Equatable {
  final DFRendererStatus status;
  final List<DynamicField> fields;
  final Map<String, dynamic> values;
  final bool submitted;
  final String message;

  const DFRendererState({
    required this.status,
    required this.fields,
    required this.values,
    required this.submitted,
    required this.message,
  });

  bool get ready => status == DFRendererStatus.success;

  static const DFRendererState initial = DFRendererState(
    status: DFRendererStatus.initial,
    fields: [],
    values: {},
    submitted: false,
    message: '',
  );

  DFRendererState copyWith({
    DFRendererStatus Function()? status,
    List<DynamicField> Function()? fields,
    Map<String, dynamic> Function()? values,
    bool Function()? submitted,
    String Function()? message,
  }) {
    return DFRendererState(
      status: status?.call() ?? this.status,
      fields: fields?.call() ?? this.fields,
      values: values?.call() ?? this.values,
      submitted: submitted?.call() ?? this.submitted,
      message: message?.call() ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, fields, values, submitted, message];
}

import 'package:equatable/equatable.dart';

class DynamicField extends Equatable {
  final String type;
  final String label;
  final String key;
  final bool required;
  final List<String> options;
  final num? min;
  final num? max;

  const DynamicField({
    required this.type,
    required this.label,
    required this.key,
    required this.required,
    this.options = const [],
    this.min,
    this.max,
  });

  DynamicField copyWith({
    String? type,
    String? label,
    String? key,
    bool? required,
    List<String>? options,
    num? min,
    num? max,
  }) {
    return DynamicField(
      type: type ?? this.type,
      label: label ?? this.label,
      key: key ?? this.key,
      required: required ?? this.required,
      options: options ?? this.options,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  factory DynamicField.fromJson(Map<String, dynamic> json) {
    return DynamicField(
      type: json['type'] as String? ?? '',
      label: json['label'] as String? ?? '',
      key: json['key'] as String? ?? '',
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List?)?.cast<String>() ?? const [],
      min: json['min'] as num?,
      max: json['max'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'label': label,
    'key': key,
    'required': required,
    if (options.isNotEmpty) 'options': options,
    if (min != null) 'min': min,
    if (max != null) 'max': max,
  };

  factory DynamicField.empty() {
    return const DynamicField(
      type: '',
      label: '',
      key: '',
      required: false,
      options: [],
    );
  }

  @override
  List<Object?> get props => [type, label, key, required, options, min, max];
}

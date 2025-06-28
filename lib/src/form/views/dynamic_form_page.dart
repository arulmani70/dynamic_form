import 'dart:convert';
import 'dart:ui';

import 'package:dynamic_form/src/common/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Replace with real JSON (could come from API/local asset)
const _sampleJson = '''[
  {"type":"text","label":"Full Name","key":"name","required":true},
  {"type":"dropdown","label":"Gender","key":"gender","options":["Male","Female","Other"],"required":true},
  {"type":"number","label":"Age","key":"age","required":false,"min":1,"max":120}
]''';

class DynamicFormPage extends StatefulWidget {
  const DynamicFormPage({super.key});

  @override
  State<DynamicFormPage> createState() => _DynamicFormPageState();
}

class _DynamicFormPageState extends State<DynamicFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late List<DynamicField> _fields;

  @override
  void initState() {
    super.initState();
    _fields = (jsonDecode(_sampleJson) as List<dynamic>)
        .map((e) => DynamicField.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            children: [
              ..._fields.map(_buildField),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(DynamicField f) {
    switch (f.type) {
      case 'text':
        return FormBuilderTextField(
          name: f.key,
          decoration: InputDecoration(labelText: f.label),
          validator: f.required
              ? FormBuilderValidators.required(errorText: 'Required')
              : null,
        );
      case 'number':
        return FormBuilderTextField(
          name: f.key,
          decoration: InputDecoration(labelText: f.label),
          keyboardType: TextInputType.number,
          validator: FormBuilderValidators.compose([
            if (f.required)
              FormBuilderValidators.required(errorText: 'Required'),
            if (f.min != null)
              FormBuilderValidators.min(
                f.min!,
                errorText: 'Min ${f.min}',
              ), // 🚩 removed context
            if (f.max != null)
              FormBuilderValidators.max(
                f.max!,
                errorText: 'Max ${f.max}',
              ), // 🚩 removed context
          ]),
        );
      case 'dropdown':
        return FormBuilderDropdown<String>(
          name: f.key,
          decoration: InputDecoration(labelText: f.label),
          items: f.options!
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          validator: f.required ? FormBuilderValidators.required() : null,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _submit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final result = _formKey.currentState!.value;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Data'),
          content: Text(result.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:dynamic_form/src/common/models/models.dart';
import 'package:dynamic_form/src/form_manager/form_renderer/bloc/df_renderer_bloc.dart';

class DynamicFormRendererPage extends StatefulWidget {
  const DynamicFormRendererPage({super.key});
  @override
  State<DynamicFormRendererPage> createState() =>
      _DynamicFormRendererPageState();
}

class _DynamicFormRendererPageState extends State<DynamicFormRendererPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  InputDecoration _dec(String lbl) => InputDecoration(
    labelText: lbl,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _wrap(Widget child) => Card(
    margin: const EdgeInsets.symmetric(vertical: 12),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(padding: const EdgeInsets.all(20), child: child),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DFRendererBloc, DFRendererState>(
      builder: (_, state) {
        if (state.fields.isEmpty) {
          return const Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: SizedBox(),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        String appTitle = 'Dynamic Form';
        if (state.fields.first.type == 'title') {
          appTitle = state.fields.first.label;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            actions: [
              IconButton(
                tooltip: 'Reset',
                icon: const Icon(Icons.refresh),
                onPressed: () => _formKey.currentState?.reset(),
              ),
            ],
          ),
          body: FormBuilder(
            key: _formKey,
            onChanged: () => context.read<DFRendererBloc>().add(
              DFRendererFieldChanged(_formKey.currentState?.instantValue ?? {}),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...state.fields.map(_buildField),
                const SizedBox(height: 28),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.save),
                  label: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _noBlank(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  Widget _buildField(DynamicField f) {
    final validators = <String? Function(String?)>[
      if (f.required) _noBlank,
      if (f.type == 'email' || f.key.toLowerCase().contains('email'))
        FormBuilderValidators.email(errorText: 'Invalid e‑mail'),
      if (f.min != null) FormBuilderValidators.min(f.min!),
      if (f.max != null) FormBuilderValidators.max(f.max!),
    ];

    switch (f.type) {
      case 'title':
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            f.label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        );

      case 'section':
        return Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 8),
          child: Text(
            f.label,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        );

      case 'text':
        return _wrap(
          FormBuilderTextField(
            name: f.key,
            decoration: _dec(f.label),
            validator: FormBuilderValidators.compose(validators),
          ),
        );

      case 'number':
        return _wrap(
          FormBuilderTextField(
            name: f.key,
            decoration: _dec(f.label),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose(validators),
          ),
        );

      case 'dropdown':
        return _wrap(
          FormBuilderDropdown<String>(
            name: f.key,
            decoration: _dec(f.label),
            items: f.options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            validator: FormBuilderValidators.compose(validators),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      context.read<DFRendererBloc>().add(DFRendererSubmitted(values));

      showAdaptiveDialog(
        context: context,
        builder: (_) => AlertDialog.adaptive(
          title: const Text('Submitted Data'),
          content: SelectableText(values.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix validation errors')),
      );
    }
  }
}

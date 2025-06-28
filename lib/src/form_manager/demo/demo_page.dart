import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dynamic_form/src/form_manager/form_renderer/repo/form_loader_repository.dart';
import 'package:dynamic_form/src/app/route_names.dart';

class DynamicFormDemoPage extends StatelessWidget {
  const DynamicFormDemoPage({super.key});

  Future<void> _openForm(BuildContext ctx, String assetPath) async {
    final repo = ctx.read<FormLoaderRepository>();

    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final json = await repo.loadFromAsset(assetPath);
      Navigator.pop(ctx);

      ctx.pushNamed(RouteNames.renderer, extra: json);
    } catch (e) {
      Navigator.pop(ctx);
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(SnackBar(content: Text('Failed to load form → $e')));
    }
  }

  Widget _demoButton(
    BuildContext ctx, {
    required IconData icon,
    required String label,
    required String assetPath,
  }) => FilledButton.icon(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    icon: Icon(icon),
    label: Text(label),
    onPressed: () => _openForm(ctx, assetPath),
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form Showcase')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.secondaryContainer, cs.surfaceVariant],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose a demo form',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            _demoButton(
              context,
              icon: Icons.person,
              label: 'Basic Profile',
              assetPath: 'assets/forms/basic_profile.json',
            ),
            const SizedBox(height: 20),

            _demoButton(
              context,
              icon: Icons.business_center,
              label: 'Employee On‑Boarding',
              assetPath: 'assets/forms/employee_onboarding.json',
            ),
          ],
        ),
      ),
    );
  }
}

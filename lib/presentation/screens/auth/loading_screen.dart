import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppDesignSystem.surfaceDarkSecondary 
          : AppDesignSystem.surface,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return const AppLoadingWidget(
      message: 'Loading...',
    );
  }
}

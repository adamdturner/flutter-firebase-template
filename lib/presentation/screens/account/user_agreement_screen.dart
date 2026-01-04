import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/presentation/widgets/common/custom_app_bar_widget.dart';
import 'package:flutter_firebase_template/core/design_system.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "User Agreement"),
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppDesignSystem.surfaceDarkSecondary 
          : AppDesignSystem.surface,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return const Center(child: Text("You agree to our terms and conditions"));
  }
}

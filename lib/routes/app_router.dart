import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/presentation/screens/about/about_us_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/auth/login_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/auth/signup_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/auth/loading_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/auth/forgot_password_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/central_hub/central_hub_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/examples/examples_dashboard_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/examples/form_fields_example_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/examples/info_widget_example_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/examples/list_example_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/account/user_account_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/account/user_agreement_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/account/report_issue_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/admin/add_admin_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/admin/admin_issue_reports_screen.dart';
import 'package:flutter_firebase_template/presentation/screens/admin/admin_issue_report_detail_screen.dart';
import 'package:flutter_firebase_template/data/models/issue_report_model.dart';

/// Centralized routing configuration for the app.
class AppRouter {
  /// Routes for public/unauthenticated access.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return _noAnimationRoute(const LoginScreen());
      case '/signup':
        return _noAnimationRoute(const SignupScreen());
      case '/forgot_password':
        return _noAnimationRoute(const ForgotPasswordScreen());
      case '/about_us':
        return _noAnimationRoute(const AboutUsScreen());
      case '/loading':
        return _noAnimationRoute(const LoadingScreen());
      default:
        return null;
    }
  }
  
  /// Routes used after user is authenticated.
  static Route<dynamic>? authenticatedRoutes(RouteSettings settings) {
    switch (settings.name) {
      // Main screens
      case '/central_hub':
        final args = settings.arguments as Map<String, dynamic>?;
        return _noAnimationRoute(
          CentralHubScreen(
            key: ValueKey(args?['refreshKey'] ?? 'default'),
          ),
        );
      
      // Examples
      case '/examples':
        return _noAnimationRoute(const ExamplesDashboardScreen());
      case '/examples/form_fields':
        return _noAnimationRoute(const FormFieldsExampleScreen());
      case '/examples/info_widgets':
        return _noAnimationRoute(const InfoWidgetExampleScreen());
      case '/examples/list':
        return _noAnimationRoute(const ListExampleScreen());

      // Account screens
      case '/account':
        return _noAnimationRoute(const UserAccountScreen());
      case '/report_issue':
        return _noAnimationRoute(const ReportIssueScreen());
      case '/user_agreement':
        return _noAnimationRoute(const UserAgreementScreen());
      
      // Admin screens
      case '/add_admin':
        return _noAnimationRoute(const AddAdminScreen());
      case '/admin_issue_reports':
        return _noAnimationRoute(const AdminIssueReportsScreen());
      case '/admin_issue_report_detail':
        final issueReport = settings.arguments as IssueReport;
        return _noAnimationRoute(
          AdminIssueReportDetailScreen(issueReport: issueReport),
        );
      
      // Placeholder routes for screens not yet implemented
      case '/profile':
      case '/settings':
        return _noAnimationRoute(
          _PlaceholderScreen(routeName: settings.name ?? 'Unknown'),
        );
      
      default:
        return null;
    }
  }
}

/// Helper function to create a route with no animation.
Route<dynamic> _noAnimationRoute(Widget page, {RouteSettings? settings}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

/// Placeholder screen for routes not yet implemented.
class _PlaceholderScreen extends StatelessWidget {
  final String routeName;
  
  const _PlaceholderScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routeName.replaceAll('/', '').toUpperCase()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The $routeName screen is not yet implemented.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

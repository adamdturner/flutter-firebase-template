import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/core/design_system.dart';
import 'package:flutter_firebase_template/presentation/widgets/common/info_card_widget.dart';
import 'package:flutter_firebase_template/presentation/widgets/widgets.dart';

/// About Us screen showcasing template sections and layout.
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'About Us',
        showBackButton: true,
      ),
      backgroundColor: isDark
          ? AppDesignSystem.surfaceDarkSecondary
          : AppDesignSystem.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDesignSystem.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(context, isDark),
              
              SizedBox(height: AppDesignSystem.spacing32),
              
              // Mission Statement
              _buildSectionHeader(context, 'Our Mission', isDark),
              SizedBox(height: AppDesignSystem.spacing12),
              _buildTextCard(
                context,
                isDark,
                'We are committed to providing innovative solutions that empower our users. '
                'Our platform leverages cutting-edge technology to deliver exceptional experiences '
                'that make a real difference in people\'s lives.',
              ),
              
              SizedBox(height: AppDesignSystem.spacing32),
              
              // Features Section
              _buildSectionHeader(context, 'What We Offer', isDark),
              SizedBox(height: AppDesignSystem.spacing16),
              _buildFeatureList(context, isDark),
              
              SizedBox(height: AppDesignSystem.spacing32),
              
              // Values Section
              _buildSectionHeader(context, 'Our Values', isDark),
              SizedBox(height: AppDesignSystem.spacing16),
              _buildValuesList(context, isDark),
              
              SizedBox(height: AppDesignSystem.spacing32),
              
              // Team Section
              _buildSectionHeader(context, 'Meet the Team', isDark),
              SizedBox(height: AppDesignSystem.spacing12),
              _buildTextCard(
                context,
                isDark,
                'Our team consists of passionate professionals dedicated to building '
                'the best possible product. With diverse backgrounds in technology, design, '
                'and business, we bring unique perspectives to every challenge.',
              ),
              
              SizedBox(height: AppDesignSystem.spacing32),
              
              // Technology Section
              _buildSectionHeader(context, 'Built With', isDark),
              SizedBox(height: AppDesignSystem.spacing16),
              _buildTechStack(context, isDark),
              
              SizedBox(height: AppDesignSystem.spacing32),
              
              // Contact Section
              _buildSectionHeader(context, 'Get In Touch', isDark),
              SizedBox(height: AppDesignSystem.spacing12),
              _buildContactCard(context, isDark),
              
              SizedBox(height: AppDesignSystem.spacing32),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds the hero section at the top.
  Widget _buildHeroSection(BuildContext context, bool isDark) {
    return InfoCard.displayOnly(
      icon: Icons.info_outline,
      title: 'Welcome to Our App',
      subtitle: 'Building the future, one feature at a time',
      padding: EdgeInsets.all(AppDesignSystem.spacing24),
    );
  }
  
  /// Builds a section header with consistent styling.
  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: AppTextStyles.heading2.copyWith(
        color: isDark ? AppDesignSystem.onSurfaceDark : AppDesignSystem.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  /// Builds a text content card.
  Widget _buildTextCard(BuildContext context, bool isDark, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Text(
        content,
        style: AppTextStyles.body.copyWith(
          color: isDark
              ? AppDesignSystem.onSurfaceDarkSecondary
              : Colors.grey.shade700,
          height: 1.6,
        ),
      ),
    );
  }
  
  /// Builds the features list.
  Widget _buildFeatureList(BuildContext context, bool isDark) {
    final features = [
      _FeatureItem(
        icon: Icons.security,
        title: 'Secure & Private',
        description: 'Your data is protected with industry-standard encryption',
      ),
      _FeatureItem(
        icon: Icons.speed,
        title: 'Fast & Reliable',
        description: 'Built for performance with minimal downtime',
      ),
      _FeatureItem(
        icon: Icons.devices,
        title: 'Cross-Platform',
        description: 'Works seamlessly across all your devices',
      ),
      _FeatureItem(
        icon: Icons.support_agent,
        title: '24/7 Support',
        description: 'Our team is always here to help you',
      ),
    ];
    
    return Column(
      children: features
          .map((feature) => _buildFeatureCard(context, isDark, feature))
          .toList(),
    );
  }
  
  /// Builds a single feature card.
  Widget _buildFeatureCard(BuildContext context, bool isDark, _FeatureItem feature) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDesignSystem.spacing12),
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDesignSystem.spacing12),
            decoration: BoxDecoration(
              color: AppDesignSystem.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
            ),
            child: Icon(
              feature.icon,
              color: AppDesignSystem.primary,
              size: AppDesignSystem.iconMedium,
            ),
          ),
          SizedBox(width: AppDesignSystem.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: AppTextStyles.listTitle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppDesignSystem.onSurfaceDark
                        : AppDesignSystem.onSurface,
                  ),
                ),
                SizedBox(height: AppDesignSystem.spacing4),
                Text(
                  feature.description,
                  style: AppTextStyles.body.copyWith(
                    color: isDark
                        ? AppDesignSystem.onSurfaceDarkSecondary
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds the values list.
  Widget _buildValuesList(BuildContext context, bool isDark) {
    final values = [
      'Innovation: Constantly pushing boundaries',
      'Integrity: Honest and transparent in everything we do',
      'Excellence: Committed to the highest quality standards',
      'Collaboration: Working together to achieve more',
      'Customer Focus: Your success is our success',
    ];
    
    return Container(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: values.asMap().entries.map((entry) {
          final isLast = entry.key == values.length - 1;
          return Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : AppDesignSystem.spacing12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppDesignSystem.primary,
                  size: AppDesignSystem.iconSmall,
                ),
                SizedBox(width: AppDesignSystem.spacing12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: AppTextStyles.body.copyWith(
                      color: isDark
                          ? AppDesignSystem.onSurfaceDarkSecondary
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  /// Builds the tech stack section.
  Widget _buildTechStack(BuildContext context, bool isDark) {
    final technologies = [
      _TechItem(icon: Icons.flutter_dash, name: 'Flutter'),
      _TechItem(icon: Icons.cloud, name: 'Firebase'),
      _TechItem(icon: Icons.storage, name: 'Cloud Firestore'),
      _TechItem(icon: Icons.lock, name: 'Firebase Auth'),
    ];
    
    return Wrap(
      spacing: AppDesignSystem.spacing12,
      runSpacing: AppDesignSystem.spacing12,
      children: technologies
          .map((tech) => _buildTechChip(context, isDark, tech))
          .toList(),
    );
  }
  
  /// Builds a tech chip.
  Widget _buildTechChip(BuildContext context, bool isDark, _TechItem tech) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacing16,
        vertical: AppDesignSystem.spacing12,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            tech.icon,
            color: AppDesignSystem.primary,
            size: AppDesignSystem.iconSmall,
          ),
          SizedBox(width: AppDesignSystem.spacing8),
          Text(
            tech.name,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppDesignSystem.onSurfaceDark
                  : AppDesignSystem.onSurface,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds the contact card.
  Widget _buildContactCard(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppDesignSystem.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.radius16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _buildContactItem(
            context,
            isDark,
            Icons.email_outlined,
            'Email',
            'contact@yourapp.com',
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildContactItem(
            context,
            isDark,
            Icons.language,
            'Website',
            'www.yourapp.com',
          ),
          SizedBox(height: AppDesignSystem.spacing16),
          _buildContactItem(
            context,
            isDark,
            Icons.location_on_outlined,
            'Location',
            'San Francisco, CA',
          ),
        ],
      ),
    );
  }
  
  /// Builds a contact item.
  Widget _buildContactItem(
    BuildContext context,
    bool isDark,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppDesignSystem.spacing8),
          decoration: BoxDecoration(
            color: AppDesignSystem.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesignSystem.radius8),
          ),
          child: Icon(
            icon,
            color: AppDesignSystem.primary,
            size: AppDesignSystem.iconSmall,
          ),
        ),
        SizedBox(width: AppDesignSystem.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppDesignSystem.onSurfaceDarkSecondary
                      : Colors.grey.shade600,
                ),
              ),
              SizedBox(height: AppDesignSystem.spacing4),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? AppDesignSystem.onSurfaceDark
                      : AppDesignSystem.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helper class for feature items.
class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;
  
  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Helper class for tech items.
class _TechItem {
  final IconData icon;
  final String name;
  
  _TechItem({
    required this.icon,
    required this.name,
  });
}

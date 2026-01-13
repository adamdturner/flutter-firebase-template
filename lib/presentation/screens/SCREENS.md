# Screens

## Purpose
Screen files represent full-page views in the application. They compose reusable widgets, listen to BLoC state changes, and dispatch events based on user interactions.

## Key Requirements
- Screens MUST NEVER reference a service file or a repository file directly
- They always use bloc/state/event to access backend methods from the UI
- Widget build method should return a scaffold with a body: SafeArea() inside the scaffold
- Different sections of UI should be abstracted out to separate methods for better readability
- Use design system constants for all styling
- Handle all state changes through BlocBuilder/BlocListener

## Screen Structure
1. **State Management**: Use BlocBuilder for UI updates, BlocListener for side effects
2. **Main Build**: Return Scaffold with SafeArea
3. **UI Sections**: Extract into private methods (_buildBody, _buildHeader, etc.)
4. **Event Dispatching**: Call context.read<BLoC>().add(Event()) for actions

## UI Section Methods

Example method names:
- `_buildBody()`
- `_buildSectionHeader()`
- `_buildSectionCard()`
- `_buildActionButtons()`
- `_buildListItem()`

## Example

```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const AppLoadingWidget(
                message: 'Loading profile...',
                isFullScreen: true,
              );
            } else if (state is UserLoaded) {
              return _buildBody(context, state.user);
            } else if (state is UserError) {
              return _buildErrorState(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Body section with scrollable content
  Widget _buildBody(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDesignSystem.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context, user),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildProfileDetails(context, user),
          SizedBox(height: AppDesignSystem.spacing24),
          _buildActionButtons(context, user),
        ],
      ),
    );
  }

  // Header section with avatar and name
  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppDesignSystem.avatarSize / 2,
          backgroundImage: user.profileImageUrl != null
              ? NetworkImage(user.profileImageUrl!)
              : null,
          child: user.profileImageUrl == null
              ? Text(user.firstName[0].toUpperCase())
              : null,
        ),
        SizedBox(width: AppDesignSystem.spacing16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: AppTextStyles.heading2,
              ),
              SizedBox(height: AppDesignSystem.spacing4),
              Text(
                user.email,
                style: AppTextStyles.body.copyWith(
                  color: AppDesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Details section with user information
  Widget _buildProfileDetails(BuildContext context, UserModel user) {
    return InfoCardWidget(
      title: 'Profile Information',
      children: [
        ListTile(
          title: Text('Phone'),
          subtitle: Text(user.phoneNumber ?? 'Not provided'),
        ),
        ListTile(
          title: Text('Role'),
          subtitle: Text(user.role),
        ),
      ],
    );
  }

  // Action buttons section
  Widget _buildActionButtons(BuildContext context, UserModel user) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Dispatch event to BLoC - never call repository directly
            context.read<UserBloc>().add(EditProfileRequested());
          },
          child: Text('Edit Profile'),
        ),
        SizedBox(height: AppDesignSystem.spacing12),
        OutlinedButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
          },
          child: Text('Sign Out'),
        ),
      ],
    );
  }

  // Error state
  Widget _buildErrorState(BuildContext context, String message) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: 'Error Loading Profile',
      message: message,
      actionLabel: 'Retry',
      onAction: () {
        final uid = context.read<AuthBloc>().state.user.uid;
        context.read<UserBloc>().add(LoadUser(uid));
      },
    );
  }
}
```

## Best Practices
- Keep build methods clean and readable
- Extract complex UI sections into separate methods
- Use reusable widgets from `presentation/widgets/`
- Handle loading, success, and error states
- Never call repositories or services directly
- Always dispatch events through BLoC

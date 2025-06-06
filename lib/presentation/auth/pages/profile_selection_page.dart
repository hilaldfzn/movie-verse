import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../application/auth/bloc/auth_bloc.dart';
import '../../../application/auth/profile/bloc/profile_bloc.dart' as profile_bloc;
import '../../../core/constants/route_constants.dart';
import '../../../core/utils/helpers.dart';
import '../widgets/profile_card.dart';

class ProfileSelectionPage extends StatefulWidget {
  const ProfileSelectionPage({super.key});

  @override
  State<ProfileSelectionPage> createState() => _ProfileSelectionPageState();
}

class _ProfileSelectionPageState extends State<ProfileSelectionPage> {
  @override
  void initState() {
    super.initState();
    // Load profiles for current user with delay to ensure proper initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfiles();
    });
  }

  void _loadProfiles() {
    final authState = context.read<AuthBloc>().state;
    print('Auth state: $authState'); // Debug log
    
    if (authState is LoginSuccess) {
      print('Loading profiles for user: ${authState.user.id}'); // Debug log
      context.read<profile_bloc.ProfileBloc>().add(
        profile_bloc.LoadProfilesEvent(authState.user.id)
      );
    } else {
      print('User not logged in, redirecting to login'); // Debug log
      context.go(RouteConstants.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              context.go(RouteConstants.login);
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<profile_bloc.ProfileBloc, profile_bloc.ProfileState>(
            listener: (context, state) {
              print('Profile state changed: $state'); // Debug log
              
              if (state is profile_bloc.ProfileSelected) {
                context.go(RouteConstants.movieList);
              } else if (state is profile_bloc.ProfileError) {
                AppHelpers.showSnackBar(context, state.message, isError: true);
              } else if (state is profile_bloc.ProfileCreated) {
                AppHelpers.showSnackBar(context, 'Profile created successfully!');
                // Reload profiles
                _loadProfiles();
              }
            },
          ),
        ],
        child: BlocBuilder<profile_bloc.ProfileBloc, profile_bloc.ProfileState>(
          builder: (context, state) {
            print('Building with profile state: $state'); // Debug log
            
            if (state is profile_bloc.ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is profile_bloc.ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadProfiles,
                      child: const Text('Retry'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _showCreateProfileDialog,
                      child: const Text('Create First Profile'),
                    ),
                  ],
                ),
              );
            }

            if (state is profile_bloc.ProfilesLoaded) {
              if (state.profiles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_add, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No profiles yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your first profile to get started',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _showCreateProfileDialog,
                        child: const Text('Create Profile'),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Who\'s watching?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.profiles.length + 1, // +1 for add profile
                        itemBuilder: (context, index) {
                          if (index == state.profiles.length) {
                            // Add new profile card
                            return _buildAddProfileCard();
                          }

                          final profile = state.profiles[index];
                          return ProfileCard(
                            profile: profile,
                            onTap: () => _selectProfile(profile.id!),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            // Initial state - show loading
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildAddProfileCard() {
    return Card(
      child: InkWell(
        onTap: _showCreateProfileDialog,
        borderRadius: BorderRadius.circular(12),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Add Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectProfile(int profileId) {
    context.read<profile_bloc.ProfileBloc>().add(
      profile_bloc.SelectProfileEvent(profileId)
    );
  }

  void _showCreateProfileDialog() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Profile'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Profile Name',
            hintText: 'Enter profile name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final authState = context.read<AuthBloc>().state;
                if (authState is LoginSuccess) {
                  context.read<profile_bloc.ProfileBloc>().add(
                    profile_bloc.CreateProfileEvent(
                      name: nameController.text.trim(),
                      userId: authState.user.id,
                    )
                  );
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../application/auth/bloc/auth_bloc.dart';
import '../../../application/auth/profile/bloc/profile_bloc.dart';
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
    // Load profiles for current user
    final authState = context.read<AuthBloc>().state;
    if (authState is LoginSuccess) {
      context.read<ProfileBloc>().add(LoadProfilesEvent(authState.user.id));
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
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSelected) {
                context.go(RouteConstants.movieList);
              } else if (state is ProfileError) {
                AppHelpers.showSnackBar(context, state.message, isError: true);
              } else if (state is ProfileCreated) {
                AppHelpers.showSnackBar(context, 'Profile created successfully!');
                // Reload profiles
                final authState = context.read<AuthBloc>().state;
                if (authState is LoginSuccess) {
                  context.read<ProfileBloc>().add(LoadProfilesEvent(authState.user.id));
                }
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfilesLoaded) {
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

            return const Center(
              child: Text('No profiles found'),
            );
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
    context.read<ProfileBloc>().add(SelectProfileEvent(profileId));
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
                  context.read<ProfileBloc>().add(CreateProfileEvent(
                    name: nameController.text.trim(),
                    userId: authState.user.id,
                  ));
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
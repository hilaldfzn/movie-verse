import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';
import '../../core/storage/in_memory_storage.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
  Future<ProfileModel> createProfile(ProfileModel profile);
  Future<List<ProfileModel>> getProfiles(String userId);
  Future<void> selectProfile(int profileId);
  Future<ProfileModel?> getCurrentProfile();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final InMemoryStorage storage;

  static const String cachedUserKey = 'CACHED_USER';
  static const String selectedProfileKey = 'SELECTED_PROFILE';

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.storage,
  });

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUserKey);
      if (jsonString != null) {
        final user = UserModel.fromJson(json.decode(jsonString));
        print('👤 Retrieved cached user: ${user.username}');
        return user;
      }
      return null;
    } catch (e) {
      print('❌ Failed to get cached user: $e');
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        cachedUserKey,
        json.encode(user.toJson()),
      );
      print('💾 User cached: ${user.username}');
    } catch (e) {
      print('❌ Failed to cache user: $e');
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
      await sharedPreferences.remove(selectedProfileKey);
      print('🧹 User data cleared');
    } catch (e) {
      print('❌ Failed to clear user: $e');
      throw CacheException('Failed to clear user: $e');
    }
  }

  @override
  Future<ProfileModel> createProfile(ProfileModel profile) async {
    try {
      print('➕ Creating profile: ${profile.name}');
      
      final createdProfile = await storage.createProfile(
        profile.name,
        profile.avatar,
        profile.userId,
      );
      
      return ProfileModel(
        id: createdProfile.id,
        name: createdProfile.name,
        avatar: createdProfile.avatar,
        userId: createdProfile.userId,
        createdAt: createdProfile.createdAt,
      );
    } catch (e) {
      print('❌ Failed to create profile: $e');
      throw CacheException('Failed to create profile: $e');
    }
  }

  @override
  Future<List<ProfileModel>> getProfiles(String userId) async {
    try {
      print('📋 Getting profiles for user: $userId');
      
      final profiles = await storage.getProfiles(userId);
      
      return profiles.map((profile) => ProfileModel(
        id: profile.id,
        name: profile.name,
        avatar: profile.avatar,
        userId: profile.userId,
        createdAt: profile.createdAt,
      )).toList();
    } catch (e) {
      print('❌ Failed to get profiles: $e');
      throw CacheException('Failed to get profiles: $e');
    }
  }

  @override
  Future<void> selectProfile(int profileId) async {
    try {
      await sharedPreferences.setInt(selectedProfileKey, profileId);
      print('✅ Profile selected: $profileId');
    } catch (e) {
      print('❌ Failed to select profile: $e');
      throw CacheException('Failed to select profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getCurrentProfile() async {
    try {
      final profileId = sharedPreferences.getInt(selectedProfileKey);
      if (profileId == null) {
        print('ℹ️ No profile selected');
        return null;
      }

      final profile = await storage.getProfileById(profileId);
      if (profile != null) {
        print('👤 Current profile: ${profile.name}');
        return ProfileModel(
          id: profile.id,
          name: profile.name,
          avatar: profile.avatar,
          userId: profile.userId,
          createdAt: profile.createdAt,
        );
      }
      
      print('⚠️ Selected profile not found');
      return null;
    } catch (e) {
      print('❌ Failed to get current profile: $e');
      throw CacheException('Failed to get current profile: $e');
    }
  }
}
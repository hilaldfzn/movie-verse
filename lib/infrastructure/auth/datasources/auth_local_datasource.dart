import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';
import '../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';

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
  final Database database;

  static const String cachedUserKey = 'CACHED_USER';
  static const String selectedProfileKey = 'SELECTED_PROFILE';

  AuthLocalDataSourceImpl(this.sharedPreferences) : database = GetIt.instance<Database>();

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(cachedUserKey);
    await sharedPreferences.remove(selectedProfileKey);
  }

  @override
  Future<ProfileModel> createProfile(ProfileModel profile) async {
    try {
      final id = await database.insert(
        'profiles',
        profile.toJson()..remove('id'),
      );
      
      return ProfileModel(
        id: id,
        name: profile.name,
        avatar: profile.avatar,
        userId: profile.userId,
        createdAt: profile.createdAt,
      );
    } catch (e) {
      throw CacheException('Failed to create profile: $e');
    }
  }

  @override
  Future<List<ProfileModel>> getProfiles(String userId) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'profiles',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      return maps.map((map) => ProfileModel.fromJson(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get profiles: $e');
    }
  }

  @override
  Future<void> selectProfile(int profileId) async {
    await sharedPreferences.setInt(selectedProfileKey, profileId);
  }

  @override
  Future<ProfileModel?> getCurrentProfile() async {
    final profileId = sharedPreferences.getInt(selectedProfileKey);
    if (profileId == null) return null;

    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'profiles',
        where: 'id = ?',
        whereArgs: [profileId],
      );

      if (maps.isNotEmpty) {
        return ProfileModel.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get current profile: $e');
    }
  }
}
part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {
  final int profileId;

  const LoadFavoritesEvent(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

class AddToFavoritesEvent extends FavoritesEvent {
  final Movie movie;
  final int profileId;

  const AddToFavoritesEvent({
    required this.movie,
    required this.profileId,
  });

  @override
  List<Object?> get props => [movie, profileId];
}

class RemoveFromFavoritesEvent extends FavoritesEvent {
  final int movieId;
  final int profileId;

  const RemoveFromFavoritesEvent({
    required this.movieId,
    required this.profileId,
  });

  @override
  List<Object?> get props => [movieId, profileId];
}

class CheckFavoriteStatusEvent extends FavoritesEvent {
  final int movieId;
  final int profileId;

  const CheckFavoriteStatusEvent({
    required this.movieId,
    required this.profileId,
  });

  @override
  List<Object?> get props => [movieId, profileId];
}
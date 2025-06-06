part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteMovie> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoriteAdded extends FavoritesState {
  final FavoriteMovie favorite;

  const FavoriteAdded(this.favorite);

  @override
  List<Object?> get props => [favorite];
}

class FavoriteRemoved extends FavoritesState {
  final int movieId;

  const FavoriteRemoved(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class FavoriteStatusChecked extends FavoritesState {
  final bool isFavorite;

  const FavoriteStatusChecked(this.isFavorite);

  @override
  List<Object?> get props => [isFavorite];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
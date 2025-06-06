import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/movies/entities/movie.dart';
import '../../../domain/favorites/entities/favorite_movie.dart';
import '../../../domain/favorites/usecases/add_to_favorites.dart';
import '../../../domain/favorites/usecases/remove_from_favorites.dart';
import '../../../domain/favorites/usecases/get_favorites.dart';
import '../../../domain/favorites/usecases/check_favorite_status.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final AddToFavorites addToFavorites;
  final RemoveFromFavorites removeFromFavorites;
  final GetFavorites getFavorites;
  final CheckFavoriteStatus checkFavoriteStatus;

  FavoritesBloc({
    required this.addToFavorites,
    required this.removeFromFavorites,
    required this.getFavorites,
    required this.checkFavoriteStatus,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    
    final result = await getFavorites(GetFavoritesParams(profileId: event.profileId));
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onAddToFavorites(
    AddToFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await addToFavorites(AddToFavoritesParams(
      movie: event.movie,
      profileId: event.profileId,
    ));
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorite) => emit(FavoriteAdded(favorite)),
    );
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFromFavorites(RemoveFromFavoritesParams(
      movieId: event.movieId,
      profileId: event.profileId,
    ));
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => emit(FavoriteRemoved(event.movieId)),
    );
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatusEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await checkFavoriteStatus(CheckFavoriteStatusParams(
      movieId: event.movieId,
      profileId: event.profileId,
    ));
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (isFavorite) => emit(FavoriteStatusChecked(isFavorite)),
    );
  }
}
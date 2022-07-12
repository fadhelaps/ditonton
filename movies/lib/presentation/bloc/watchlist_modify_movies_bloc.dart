import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';

class WatchListModifyMoviesBloc extends Bloc<WatchListMoviesModifyEvent, WatchListModifyMoviesState> {

  final SaveMoviesWatchlist saveMoviesWatchlist;
  final RemoveMoviesWatchlist removeMoviesWatchlist;

  WatchListModifyMoviesBloc({
    required this.saveMoviesWatchlist,
    required this.removeMoviesWatchlist,
  }) : super(WatchListModifyMoviesEmpty()) {
    on<AddMovie>(_addMoviesWatchlist);
    on<RemoveMovie>(_removeMoviesWatchlist);
  }

  void _addMoviesWatchlist(
      AddMovie addMovie,
      Emitter<WatchListModifyMoviesState> emit
    ) async {
      emit(WatchListModifyMoviesLoading());
      final result = await saveMoviesWatchlist.execute(addMovie.movieDetail);

      result.fold(
        (failure) => emit(WatchListModifyMoviesError(failure.message)),
        (success) => emit(AddedMovies(success)),
      );
    }

  void _removeMoviesWatchlist(
      RemoveMovie removeMovie,
      Emitter<WatchListModifyMoviesState> emit
    ) async {
      emit(WatchListModifyMoviesLoading());
      final result = await removeMoviesWatchlist.execute(removeMovie.movieDetail);

      result.fold(
        (failure) => emit(WatchListModifyMoviesError(failure.message)),
        (success) => emit(MoviesRemoved(success)),
      );
    }
}


abstract class WatchListModifyMoviesState extends Equatable {}

class WatchListModifyMoviesEmpty extends WatchListModifyMoviesState {
  @override
  List<Object> get props => [];
}

class WatchListModifyMoviesLoading extends WatchListModifyMoviesState {
  @override
  List<Object> get props => [];
}

class AddedMovies extends WatchListModifyMoviesState {
  final String message;

  AddedMovies(this.message);

  @override
  List<Object> get props => [message];
}

class MoviesRemoved extends WatchListModifyMoviesState {
  final String message;

  MoviesRemoved(this.message);

  @override
  List<Object> get props => [message];
}

class WatchListModifyMoviesError extends WatchListModifyMoviesState {
  final String message;

  WatchListModifyMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class WatchListMoviesModifyEvent extends Equatable {}

class AddMovie extends WatchListMoviesModifyEvent {
  final MovieDetail movieDetail;

  AddMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveMovie extends WatchListMoviesModifyEvent {
  final MovieDetail movieDetail;

  RemoveMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}
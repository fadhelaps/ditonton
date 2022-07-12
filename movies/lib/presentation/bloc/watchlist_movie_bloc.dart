import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';

class WatchlistMoviesBloc extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc({required this.getWatchlistMovies}) : super(WatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>(_fetchWatchlistMovies);
  }

  void _fetchWatchlistMovies(FetchWatchlistMovies fetchWatchlistMovies, Emitter<WatchlistMoviesState> emit) async {
    emit(WatchlistMoviesLoading());
    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(WatchlistMoviesError(failure.message)),
      (data) => data.isNotEmpty
          ? emit(WatchlistMoviesHasData(data))
          : emit(WatchlistMoviesEmpty()),
    );
  }
}

abstract class WatchlistMoviesState extends Equatable {}

class WatchlistMoviesEmpty extends WatchlistMoviesState {
  @override
  List<Object> get props => [];
}

class WatchlistMoviesLoading extends WatchlistMoviesState {
  @override
  List<Object> get props => [];
}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesHasData extends WatchlistMoviesState {
  final List<Movie> movies;

  WatchlistMoviesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

abstract class WatchlistMoviesEvent extends Equatable {}

class FetchWatchlistMovies extends WatchlistMoviesEvent {
  @override
  List<Object> get props => [];
}

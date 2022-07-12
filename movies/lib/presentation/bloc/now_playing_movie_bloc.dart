import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';

class NowPlayingMoviesBloc extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc({
    required this.getNowPlayingMovies,
  }) : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovies>(_fetchNowPlayingMovies);
  }

  void _fetchNowPlayingMovies(FetchNowPlayingMovies fetchNowPlayingMovies, Emitter<NowPlayingMoviesState> emit) async {
    emit(NowPlayingMoviesLoading());
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(NowPlayingMoviesError(failure.message)),
      (data) => emit(NowPlayingMoviesHasData(data)),
    );
  }
}

abstract class NowPlayingMoviesState extends Equatable {}

class NowPlayingMoviesEmpty extends NowPlayingMoviesState {
  @override
  List<Object> get props => [];
}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {
  @override
  List<Object> get props => [];
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;

  NowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingMoviesHasData extends NowPlayingMoviesState {
  final List<Movie> movies;

  NowPlayingMoviesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

abstract class NowPlayingMoviesEvent extends Equatable {}

class FetchNowPlayingMovies extends NowPlayingMoviesEvent {
  @override
  List<Object> get props => [];
}

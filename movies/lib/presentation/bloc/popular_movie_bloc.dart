import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc({
    required this.getPopularMovies,
  }) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>(_fetchPopularMovies);
  }

  void _fetchPopularMovies(
      FetchPopularMovies fetchPopularMovies,
      Emitter<PopularMoviesState> emit) async {
    emit(PopularMoviesLoading());
    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(PopularMoviesError(failure.message)),
      (data) => emit(PopularMoviesHasData(data)),
    );
  }
}

abstract class PopularMoviesState extends Equatable {}

class PopularMoviesEmpty extends PopularMoviesState {
  @override
  List<Object> get props => [];
}

class PopularMoviesLoading extends PopularMoviesState {
  @override
  List<Object> get props => [];
}

class PopularMoviesError extends PopularMoviesState {
  final String message;

  PopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMoviesHasData extends PopularMoviesState {
  final List<Movie> movies;

  PopularMoviesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

abstract class PopularMoviesEvent extends Equatable {}

class FetchPopularMovies extends PopularMoviesEvent {
  @override
  List<Object> get props => [];
}

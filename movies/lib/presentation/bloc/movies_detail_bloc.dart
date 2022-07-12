import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


class MoviesDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MoviesDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super((MovieDetailEmpty())) {
    on<FetchMovieDetail>(_fetchMovieDetail);
  }

  void _fetchMovieDetail(
      FetchMovieDetail fetchMovieDetail,
      Emitter<MovieDetailState> emit) async {
    emit(MovieDetailLoading());
    final resultDetail = await getMovieDetail.execute(fetchMovieDetail.id);
    final resultRecommendations = await getMovieRecommendations.execute(fetchMovieDetail.id);
    resultDetail.fold((failure) => emit(MovieDetailError(failure.message)),
        (movieDetail) {
      emit(MovieDetailLoading());
      resultRecommendations.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movieRecommendations) => emit(
          MovieDetailHasData(movieDetail, movieRecommendations),
        ),
      );
    });
  }
}

abstract class MovieDetailState extends Equatable {}

class MovieDetailEmpty extends MovieDetailState {
  @override
  List<Object> get props => [];
}

class MovieDetailLoading extends MovieDetailState {
  @override
  List<Object> get props => [];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movieDetail;
  final List<Movie> movies;

  MovieDetailHasData(this.movieDetail, this.movies);

  @override
  List<Object> get props => [movieDetail, movies];
}

abstract class MovieDetailEvent extends Equatable {}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}


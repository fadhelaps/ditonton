import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:movies/domain/entities/movie.dart';

import 'package:search/domain/search_movies.dart';

class MoviesSearchBloc extends Bloc<MoviesSearchEvent, MoviesSearchState> {
  final SearchMovies movies;

  MoviesSearchBloc({required this.movies}) : super(MoviesSearchEmpty()) {
    on<OnMoviesQueryChanged>((event, emit) async {
      final dataQuery = event.query;

      emit(MoviesSearchLoading());
      final dataResult = await movies.execute(dataQuery);

      dataResult.fold((failure) {
        emit(MoviesSearchError(failure.message));
      }, (data) {
        emit(SearchMoviesData(data));
      });
    }, transformer: _debounceMovie(const Duration(milliseconds: 500)));
  }

  EventTransformer<OnMoviesQueryChanged> _debounceMovie<OnMoviesQueryChanged>(
      Duration dur) {
    return (events, mapper) => events.debounceTime(dur).switchMap(mapper);
  }
}

abstract class MoviesSearchState extends Equatable {}

class MoviesSearchEmpty extends MoviesSearchState {
  @override
  List<Object> get props => [];
}

class MoviesSearchLoading extends MoviesSearchState {
  @override
  List<Object> get props => [];
}

class MoviesSearchError extends MoviesSearchState {
  final String message;

  MoviesSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchMoviesData extends MoviesSearchState {
  final List<Movie> result;

  SearchMoviesData(this.result);

  @override
  List<Object> get props => [result];
}

abstract class MoviesSearchEvent extends Equatable {}

class OnMoviesQueryChanged extends MoviesSearchEvent {
  final String query;

  OnMoviesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

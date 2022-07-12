import 'package:search/presentation/bloc/movie/search_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/presentation/bloc/tv_series/search_bloc.dart';

class MockMoviesSearchBloc extends MockBloc<MoviesSearchEvent, MoviesSearchState> implements MoviesSearchBloc {}

class MockTvSeriesSearchBloc extends MockBloc<TvSeriesSearchEvent, TvSeriesSearchState> implements TvSeriesSearchBloc {}

class MoviesSearchStateFake extends Fake implements MoviesSearchState {}

class TvSeriesSearchStateFake extends Fake implements TvSeriesSearchState {}

class MoviesSearchEventFake extends Fake implements MoviesSearchEvent {}

class TvSeriesSearchEventFake extends Fake implements TvSeriesSearchEvent {}

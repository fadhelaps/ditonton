import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:movies/presentation/bloc/watchlist_modify_movies_bloc.dart';
import 'package:movies/presentation/bloc/movies_detail_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_status_movies_bloc.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState> implements MoviesDetailBloc {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MockWatchListMoviesModifyBloc extends MockBloc<WatchListMoviesModifyEvent, WatchListModifyMoviesState> implements WatchListModifyMoviesBloc {}

class WatchlistMovieModifyStateFake extends Fake implements WatchListModifyMoviesState {}

class WatchlistMovieModifyEventFake extends Fake implements WatchListMoviesModifyEvent {}

class MockWatchlistMoviesStatusBloc extends MockBloc<WatchListStatusEvent, WatchListStatusMoviesState> implements WatchListStatusMoviesBloc {}

class WatchlistStatusStateFake extends Fake implements WatchListStatusMoviesState {}

class WatchlistStatusEventFake extends Fake implements WatchListStatusEvent {}

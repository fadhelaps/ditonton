import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';

class MockWatchlistMoviesBloc extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState> implements WatchlistMoviesBloc {}

class WatchlistMoviesStateFake extends Fake implements WatchlistMoviesState {}

class WatchlistMoviesEventFake extends Fake implements WatchlistMoviesEvent {}

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_bloc.dart';

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class WatchlistTvSeriesStateFake extends Fake
    implements WatchlistTvSeriesState {}

class WatchlistTvSeriesEventFake extends Fake
    implements WatchlistTvSeriesEvent {}

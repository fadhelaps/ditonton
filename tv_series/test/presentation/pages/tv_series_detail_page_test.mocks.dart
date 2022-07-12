import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/presentation/bloc/watchlist_modify_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_status_bloc.dart';

class MockTvSeriesDetailBloc extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState> implements TvSeriesDetailBloc {}

class TvSeriesDetailStateFake extends Fake implements TvSeriesDetailState {}

class TvSeriesDetailEventFake extends Fake implements TvSeriesDetailEvent {}

class MockWatchlistTvSeriesModifyBloc extends MockBloc<WatchListModifyTvSeriesEvent, WatchListModifyTvSeriesState> implements WatchListModifyTvSeriesBloc {}

class WatchlistTvSeriesModifyStateFake extends Fake implements WatchListModifyTvSeriesState {}

class WatchlistTvSeriesModifyEventFake extends Fake implements WatchListModifyTvSeriesEvent {}

class MockWatchlistTvSeriesStatusBloc extends MockBloc<WatchlistStatusTvSeriesEvent, WatchlistStatusTvSeriesState> implements WatchlistStatusTvSeriesBloc {}

class WatchlistStatusStateFake extends Fake implements WatchlistStatusTvSeriesState {}

class WatchlistStatusEventFake extends Fake implements WatchlistStatusTvSeriesEvent {}

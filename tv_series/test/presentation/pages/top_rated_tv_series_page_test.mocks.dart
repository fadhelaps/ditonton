import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';

class MockTopRatedTvSeriesBloc extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> implements TopRatedTvSeriesBloc {}

class TopRatedTvSeriesStateFake extends Fake implements TopRatedTvSeriesState {}

class TopRatedTvSeriesEventFake extends Fake implements TopRatedTvSeriesEvent {}

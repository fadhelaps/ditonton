import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';

class MockPopularTvSeriesBloc extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState> implements PopularTvSeriesBloc {}

class PopularTvSeriesEventFake extends Fake implements PopularTvSeriesEvent {}

class PopularTvSeriesStateFake extends Fake implements PopularTvSeriesState {}

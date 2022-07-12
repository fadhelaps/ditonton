import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;
  late MockGetTopRatedTvSeries mockTopRatedTvSeries;

  setUp(() {
    mockTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesBloc =
        TopRatedTvSeriesBloc(getTopRatedTvSeries: mockTopRatedTvSeries);
  });

  group(
    'Top Rated Tv Series', () {
      test('initial state should be on page', () {
        expect(topRatedTvSeriesBloc.state, TopRatedTvSeriesEmpty());
      });

      blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          return topRatedTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchTopRatedTvSeries().props,
        expect: () => [TopRatedTvSeriesLoading(), TopRatedTvSeriesData(testTvSeriesList)],
      );

      blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful',
        build: () {
          when(mockTopRatedTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return topRatedTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchTopRatedTvSeries().props,
        expect: () => [TopRatedTvSeriesLoading(), TopRatedTvSeriesError('Failed')],
      );
    },
  );
}

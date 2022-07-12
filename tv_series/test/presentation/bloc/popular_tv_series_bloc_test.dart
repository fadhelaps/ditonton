import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesBloc popularTvSeriesBloc;
  late MockGetPopularTvSeries mockPopularTvSeries;

  setUp(() {
    mockPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesBloc = PopularTvSeriesBloc(getPopularTvSeries: mockPopularTvSeries);
  });

  group(
    'Popular Tv Series', () {
      test('initial state should be on page', () {
        expect(popularTvSeriesBloc.state, PopularTvSeriesEmpty());
      });

      blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockPopularTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          return popularTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchPopularTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchPopularTvSeries().props,
        expect: () =>
            [PopularTvSeriesLoading(), PopularTvSeriesHasData(testTvSeriesList)],
      );

      blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful', build: () {
          when(mockPopularTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return popularTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchPopularTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchPopularTvSeries().props,
        expect: () => [PopularTvSeriesLoading(), PopularTvSeriesError('Failed')],
      );
    },
  );
}

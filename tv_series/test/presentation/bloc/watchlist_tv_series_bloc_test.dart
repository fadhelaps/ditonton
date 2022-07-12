import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistTvSeriesBloc =
        WatchlistTvSeriesBloc(getWatchlistTvSeries: mockGetWatchlistTvSeries);
  });

  group(
    'Watchlist Tv Series',
    () {
      test('initial state should be on page', () {
        expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesEmpty());
      });

      blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockGetWatchlistTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          return watchlistTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchWatchlistTvSeries().props,
        expect: () => [WatchlistTvSeriesLoading(), WatchlistTvSeriesData(testTvSeriesList)],
      );

      blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful', build: () {
          when(mockGetWatchlistTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return watchlistTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchWatchlistTvSeries().props,
        expect: () =>
            [WatchlistTvSeriesLoading(), WatchlistTvSeriesError('Failed')],
      );
    },
  );
}

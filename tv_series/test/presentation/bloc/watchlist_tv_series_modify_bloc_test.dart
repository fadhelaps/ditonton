import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import '../../../lib/presentation/bloc/watchlist_modify_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_modify_bloc_test.mocks.dart';

@GenerateMocks([SaveTvSeriesWatchlist, RemoveTvSeriesWatchlist])
void main() {
  late WatchListModifyTvSeriesBloc watchListTvSeriesModifyBloc;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    watchListTvSeriesModifyBloc = WatchListModifyTvSeriesBloc(
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
    );
  });

  const saveMessage = 'Added to Watchlist';
  const removeMessage = 'Removed from Watchlist';
  const failedMessage = 'Failed';

  group(
    'Modify Watchlist Tv Series', () {
      test('initial state should be on page', () {
        expect(watchListTvSeriesModifyBloc.state, WatchListModifyTvSeriesEmpty());
      });

      blocTest<WatchListModifyTvSeriesBloc, WatchListModifyTvSeriesState>(
        'should emit [Loading, Data] when save tv is gotten successfully', build: () {
          when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
              .thenAnswer((_) async => Right(saveMessage));
          return watchListTvSeriesModifyBloc;
        },
        act: (bloc) => bloc.add(AddTvSeries(testTvSeriesDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => AddTvSeries(testTvSeriesDetail).props,
        expect: () => [WatchListModifyTvSeriesLoading(), AddedTvSeries(saveMessage)],
      );

      blocTest<WatchListModifyTvSeriesBloc, WatchListModifyTvSeriesState>(
        'should emit [Loading, Data] when save tv is gotten unsuccessfully', build: () {
          when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
              .thenAnswer((_) async => Left(DatabaseFailure(failedMessage)));
          return watchListTvSeriesModifyBloc;
        },
        act: (bloc) => bloc.add(AddTvSeries(testTvSeriesDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => AddTvSeries(testTvSeriesDetail).props,
        expect: () => [
          WatchListModifyTvSeriesLoading(),
          WatchListModifyTvSeriesError(failedMessage)
        ],
      );

      blocTest<WatchListModifyTvSeriesBloc, WatchListModifyTvSeriesState>(
        'should emit [Loading, Data] when remove tv is gotten successfully', build: () {
          when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
              .thenAnswer((_) async => Right(removeMessage));
          return watchListTvSeriesModifyBloc;
        },
        act: (bloc) => bloc.add(RemoveTvSeries(testTvSeriesDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => RemoveTvSeries(testTvSeriesDetail).props,
        expect: () =>
            [WatchListModifyTvSeriesLoading(), TvSeriesRemoved(removeMessage)],
      );

      blocTest<WatchListModifyTvSeriesBloc, WatchListModifyTvSeriesState>(
        'should emit [Loading, Data] when remove tv series is gotten unsuccessfully', build: () {
          when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
              .thenAnswer((_) async => Left(DatabaseFailure(failedMessage)));
          return watchListTvSeriesModifyBloc;
        },
        act: (bloc) => bloc.add(RemoveTvSeries(testTvSeriesDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => RemoveTvSeries(testTvSeriesDetail).props,
        expect: () => [
          WatchListModifyTvSeriesLoading(),
          WatchListModifyTvSeriesError(failedMessage)
        ],
      );
    },
  );
}

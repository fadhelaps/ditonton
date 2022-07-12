import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_series_status_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesWatchListStatus])
void main() {
  late WatchlistStatusTvSeriesBloc watchlistStatusBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    watchlistStatusBloc =
        WatchlistStatusTvSeriesBloc(getTvSeriesWatchlistStatus: mockGetWatchListStatus);
  });

  final tId = 1;

  group(
    'Watchlist Tv Series Status',
    () {
      test('initial state should be on page', () {
        expect(watchlistStatusBloc.state, WatchlistStatusTvSeriesEmpty());
      });

      blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
        'should emit [Loading, Data] when data is gotten successfully',
        build: () {
          when(mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => true);
          return watchlistStatusBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistStatusTvSeries(tId)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchWatchlistStatusTvSeries(tId).props,
        expect: () => [TvSeriesStatusState(true)],
      );
    },
  );
}

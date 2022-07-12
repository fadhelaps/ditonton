import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/presentation/bloc/watchlist_status_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movie_status_bloc_test.mocks.dart';

@GenerateMocks([GetMoviesWatchListStatus])
void main() {
  late WatchListStatusMoviesBloc watchlistStatusBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    watchlistStatusBloc =
        WatchListStatusMoviesBloc(getMoviesWatchListStatus: mockGetWatchListStatus);
  });

  final tId = 1;

  group(
    'Watchlist Movies Status', () {
      test('initial state should be on page', () {
        expect(watchlistStatusBloc.state, WatchListStatusMoviesEmpty());
      });

      blocTest<WatchListStatusMoviesBloc, WatchListStatusMoviesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => true);
          return watchlistStatusBloc;
        },
        act: (bloc) => bloc.add(FetchWatchListStatusMovies(tId)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchWatchListStatusMovies(tId).props,
        expect: () => [MoviesStatusState(true)],
      );
    },
  );
}

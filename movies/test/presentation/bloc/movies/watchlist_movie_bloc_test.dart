import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc =
        WatchlistMoviesBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  group(
    'Watchlist Movies', () {
      test('initial state should be on page', () {
        expect(watchlistMoviesBloc.state, WatchlistMoviesEmpty());
      });

      blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          return watchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchWatchlistMovies().props,
        expect: () =>
            [WatchlistMoviesLoading(), WatchlistMoviesHasData(testMovieList)],
      );

      blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful', build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return watchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchWatchlistMovies().props,
        expect: () =>
            [WatchlistMoviesLoading(), WatchlistMoviesError('Failed')],
      );
    },
  );
}

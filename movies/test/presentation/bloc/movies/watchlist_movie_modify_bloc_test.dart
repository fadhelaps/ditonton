import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';
import 'package:movies/presentation/bloc/watchlist_modify_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_modify_bloc_test.mocks.dart';

@GenerateMocks([SaveMoviesWatchlist, RemoveMoviesWatchlist])
void main() {
  late WatchListModifyMoviesBloc watchListMoviesModifyBloc;
  late MockSaveWatchlistMovies mockSaveWatchlistMovies;
  late MockRemoveWatchlistMovies mockRemoveWatchlistMovies;

  setUp(() {
    mockSaveWatchlistMovies = MockSaveWatchlistMovies();
    mockRemoveWatchlistMovies = MockRemoveWatchlistMovies();
    watchListMoviesModifyBloc = WatchListModifyMoviesBloc(
      saveMoviesWatchlist: mockSaveWatchlistMovies,
      removeMoviesWatchlist: mockRemoveWatchlistMovies,
    );
  });

  const saveMessage = 'Added to Watchlist';
  const removeMessage = 'Removed from Watchlist';
  const failedMessage = 'Failed';

  group(
    'Modify Watchlist Movies', () {
      test('initial state should be on page', () {
        expect(watchListMoviesModifyBloc.state, WatchListModifyMoviesEmpty());
      });

      blocTest<WatchListModifyMoviesBloc, WatchListModifyMoviesState>(
        'should emit [Loading, Data] when save movie is gotten successfully', build: () {
          when(mockSaveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => Right(saveMessage));
          return watchListMoviesModifyBloc;
        },
        act: (bloc) => bloc.add(AddMovie(testMovieDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => AddMovie(testMovieDetail).props,
        expect: () => [WatchListModifyMoviesLoading(), AddedMovies(saveMessage)],
      );

      blocTest<WatchListModifyMoviesBloc, WatchListModifyMoviesState>(
        'should emit [Loading, Data] when save movie is gotten unsuccessfully', build: () {
          when(mockSaveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => Left(DatabaseFailure(failedMessage)));
          return watchListMoviesModifyBloc;
        },
        act: (bloc) => bloc.add(AddMovie(testMovieDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => AddMovie(testMovieDetail).props,
        expect: () => [
          WatchListModifyMoviesLoading(),
          WatchListModifyMoviesError(failedMessage)
        ],
      );

      blocTest<WatchListModifyMoviesBloc, WatchListModifyMoviesState>(
        'should emit [Loading, Data] when remove movie is gotten successfully', build: () {
          when(mockRemoveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => Right(removeMessage));
          return watchListMoviesModifyBloc;
        },
        act: (bloc) => bloc.add(RemoveMovie(testMovieDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => RemoveMovie(testMovieDetail).props,
        expect: () =>
            [WatchListModifyMoviesLoading(), MoviesRemoved(removeMessage)],
      );

      blocTest<WatchListModifyMoviesBloc, WatchListModifyMoviesState>(
        'should emit [Loading, Data] when remove movie is gotten unsuccessfully', build: () {
          when(mockRemoveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => Left(DatabaseFailure(failedMessage)));
          return watchListMoviesModifyBloc;
        },
        act: (bloc) => bloc.add(RemoveMovie(testMovieDetail)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => RemoveMovie(testMovieDetail).props,
        expect: () => [
          WatchListModifyMoviesLoading(),
          WatchListModifyMoviesError(failedMessage)
        ],
      );
    },
  );
}

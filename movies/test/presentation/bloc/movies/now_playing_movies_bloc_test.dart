import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc =
        NowPlayingMoviesBloc(getNowPlayingMovies: mockGetNowPlayingMovies);
  });

  group(
    'Now Playing Movies', () {
      test('initial state should be on page', () {
        expect(nowPlayingMoviesBloc.state, NowPlayingMoviesEmpty());
      });

      blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          return nowPlayingMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchNowPlayingMovies().props,
        expect: () =>
            [NowPlayingMoviesLoading(), NowPlayingMoviesHasData(testMovieList)],
      );

      blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful', build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return nowPlayingMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchNowPlayingMovies().props,
        expect: () =>
            [NowPlayingMoviesLoading(), NowPlayingMoviesError('Failed')],
      );
    },
  );
}

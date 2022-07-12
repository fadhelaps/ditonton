import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockTopRatedMovies;

  setUp(() {
    mockTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc =
        TopRatedMoviesBloc(getTopRatedMovies: mockTopRatedMovies);
  });

  group(
    'Top Rated Movies', () {
      test('initial state should be on page', () {
        expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
      });

      blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockTopRatedMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          return topRatedMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchTopRatedMovies().props,
        expect: () =>
            [TopRatedMoviesLoading(), TopRatedMoviesHasData(testMovieList)],
      );

      blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful', build: () {
          when(mockTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return topRatedMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchTopRatedMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchTopRatedMovies().props,
        expect: () => [TopRatedMoviesLoading(), TopRatedMoviesError('Failed')],
      );
    },
  );
}

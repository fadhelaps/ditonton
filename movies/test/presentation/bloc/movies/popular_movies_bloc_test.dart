import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/presentation/bloc/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockPopularMovies;

  setUp(() {
    mockPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(getPopularMovies: mockPopularMovies);
  });

  group(
    'Popular Movies', () {
      test('initial state should be on page', () {
        expect(popularMoviesBloc.state, PopularMoviesEmpty());
      });

      blocTest<PopularMoviesBloc, PopularMoviesState>(
        'should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockPopularMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          return popularMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchPopularMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchPopularMovies().props,
        expect: () =>
            [PopularMoviesLoading(), PopularMoviesHasData(testMovieList)],
      );

      blocTest<PopularMoviesBloc, PopularMoviesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful', build: () {
          when(mockPopularMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return popularMoviesBloc;
        },
        act: (bloc) => bloc.add(FetchPopularMovies()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchPopularMovies().props,
        expect: () => [PopularMoviesLoading(), PopularMoviesError('Failed')],
      );
    },
  );
}

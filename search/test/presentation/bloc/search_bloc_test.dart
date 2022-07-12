import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:search/domain/search_movies.dart';
import 'package:search/domain/search_tv_series.dart';
import 'package:search/presentation/bloc/movie/search_bloc.dart';
import 'package:search/presentation/bloc/tv_series/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTvSeries])
void main() {
  late MoviesSearchBloc moviesSearchBloc;
  late TvSeriesSearchBloc tvSeriesSearchBloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTvSeries = MockSearchTvSeries();
    moviesSearchBloc = MoviesSearchBloc(movies: mockSearchMovies);
    tvSeriesSearchBloc = TvSeriesSearchBloc(tvSeries: mockSearchTvSeries);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQueryMovie = 'spiderman';

  final tTvSeriesModel = TvSeries(
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    firstAirDate: '2021-09-17',
    genreIds: const [10759, 9648, 18],
    id: 93405,
    name: 'Squid Game',
    originalLanguage: 'ko',
    originalName: 'orginal name',
    overview:
        'overview',
    popularity: 5200.044,
    posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
    voteAverage: 7.8,
    voteCount: 7842,
  );
  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  const tQueryTvSeries = 'Squid Game';

  group('search movies', () {
    test('initial state should be empty', () {
      expect(moviesSearchBloc.state, MoviesSearchEmpty());
    });
    blocTest<MoviesSearchBloc, MoviesSearchState>(
        'should emit [Loading, Data] when data is gotten successfully',
        build: () {
          when(mockSearchMovies.execute(tQueryMovie))
              .thenAnswer((_) async => Right(tMovieList));
          return moviesSearchBloc;
        },
        act: (bloc) => bloc.add(OnMoviesQueryChanged(tQueryMovie)),
        wait: const Duration(milliseconds: 500),
        expect: () => [MoviesSearchLoading(), SearchMoviesData(tMovieList)],
        verify: (bloc) => verify(mockSearchMovies.execute(tQueryMovie)));

    blocTest<MoviesSearchBloc, MoviesSearchState>(
        'should emit [Loading, Error] when data search is unsuccessful',
        build: () {
          when(mockSearchMovies.execute(tQueryMovie))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return moviesSearchBloc;
        },
        act: (bloc) => bloc.add(OnMoviesQueryChanged(tQueryMovie)),
        wait: const Duration(milliseconds: 500),
        expect: () =>
            [MoviesSearchLoading(), MoviesSearchError('Server Failure')],
        verify: (bloc) => verify(mockSearchMovies.execute(tQueryMovie)));
  });

  group('search tv series', () {
    test('initial state should be empty', () {
      expect(tvSeriesSearchBloc.state, TvSeriesSearchEmpty());
    });
    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
        'should emit [Loading, Data] when data is gotten successfully',
        build: () {
          when(mockSearchTvSeries.execute(tQueryTvSeries))
              .thenAnswer((_) async => Right(tTvSeriesList));
          return tvSeriesSearchBloc;
        },
        act: (bloc) => bloc.add(OnTvSeriesQueryChanged(tQueryTvSeries)),
        wait: const Duration(milliseconds: 500),
        expect: () => [TvSeriesSearchLoading(), SearchTvSeriesData(tTvSeriesList)],
        verify: (bloc) => verify(mockSearchTvSeries.execute(tQueryTvSeries)));

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
        'should emit [Loading, Error] when data search is unsuccessful',
        build: () {
          when(mockSearchTvSeries.execute(tQueryTvSeries))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return tvSeriesSearchBloc;
        },
        act: (bloc) => bloc.add(OnTvSeriesQueryChanged(tQueryTvSeries)),
        wait: const Duration(milliseconds: 500),
        expect: () => [TvSeriesSearchLoading(), TvSeriesSearchError('Server Failure')],
        verify: (bloc) => verify(mockSearchTvSeries.execute(tQueryTvSeries)));
  });
}

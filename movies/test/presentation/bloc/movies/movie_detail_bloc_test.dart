import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/presentation/bloc/movies_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetMovieRecommendations])
void main() {
  late MoviesDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieDetailBloc = MoviesDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  final tId = 1;

  group(
    'Get Movie Detail', () {
      test('initial state should be on page', () {
        expect(movieDetailBloc.state, MovieDetailEmpty());
      });

      blocTest<MoviesDetailBloc, MovieDetailState>(
        ' should emit [Loading, Data] when data is gotten successfully', build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(testMovieList));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(FetchMovieDetail(tId)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchMovieDetail(tId).props,
        expect: () => [
          MovieDetailLoading(),
          MovieDetailHasData(testMovieDetail, testMovieList)
        ],
      );

      blocTest<MoviesDetailBloc, MovieDetailState>(
        ' should emit [Loading, Error] when movie recommendation is gotten is unsuccessful',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(FetchMovieDetail(tId)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchMovieDetail(tId).props,
        expect: () => [MovieDetailLoading(), MovieDetailError('Failed')],
      );

      blocTest<MoviesDetailBloc, MovieDetailState>(
        ' should emit [Loading, Error] when movie detail data is gotten unsuccessful', build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(testMovieList));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(FetchMovieDetail(tId)),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchMovieDetail(tId).props,
        expect: () => [
          MovieDetailLoading(),
          MovieDetailError('Failed'),
        ],
      );
    },
  );
}

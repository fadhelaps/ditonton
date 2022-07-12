import 'package:movies/domain/entities/movie.dart';
import 'package:search/presentation/page/search_page.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/presentation/bloc/movie/search_bloc.dart';
import 'package:search/presentation/bloc/tv_series/search_bloc.dart';

import 'search_page_test_mocks.dart';

void main() {
  late final MockMoviesSearchBloc mockMoviesSearchBloc;
  late final MockTvSeriesSearchBloc mockTvSeriesSearchBloc;

  setUpAll(() {
    registerFallbackValue(MoviesSearchStateFake());
    registerFallbackValue(MoviesSearchEventFake());
    registerFallbackValue(TvSeriesSearchStateFake());
    registerFallbackValue(TvSeriesSearchEventFake());

    mockMoviesSearchBloc = MockMoviesSearchBloc();
    mockTvSeriesSearchBloc = MockTvSeriesSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesSearchBloc>.value(value: mockMoviesSearchBloc),
        BlocProvider<TvSeriesSearchBloc>.value(value: mockTvSeriesSearchBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  final testMovie = Movie(
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

  final testMovieList = [testMovie];

  final testTvSeries = TvSeries(
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    firstAirDate: '2021-09-17',
    genreIds: const [10759, 9648, 18],
    id: 93405,
    name: 'Squid Game',
    originalLanguage: 'ko',
    originalName: 'original name',
    overview: 'overview',
    popularity: 5200.044,
    posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
    voteAverage: 7.8,
    voteCount: 7842,
  );

  final testTvSeriesList = [testTvSeries];

  group('search page', () {
    testWidgets(
        'should display CircularProgressIndicator when states is MoviesSearchLoading and TvSeriesSearchLoading',
        (WidgetTester test) async {
      when(() => mockMoviesSearchBloc.state).thenReturn(MoviesSearchLoading());
      when(() => mockTvSeriesSearchBloc.state)
          .thenReturn(TvSeriesSearchLoading());

      final circular = find.byType(CircularProgressIndicator);
      await test.pumpWidget(_makeTestableWidget(const SearchPage()));

      final textField = find.byKey(const Key('search-textfield'));
      final queryText = find.text('doraemon');

      await test.enterText(textField, 'doraemon');
      await test.testTextInput.receiveAction(TextInputAction.search);

      expect(circular, findsOneWidget);
      expect(queryText, findsOneWidget);
    });

    testWidgets('should display ListView when result is not empty',
        (WidgetTester test) async {
      when(() => mockMoviesSearchBloc.state)
          .thenReturn(SearchMoviesData(testMovieList));
      when(() => mockTvSeriesSearchBloc.state)
          .thenReturn(SearchTvSeriesData(testTvSeriesList));

      final listView = find.byType(ListView);
      await test.pumpWidget(_makeTestableWidget(const SearchPage()));

      expect(listView, findsOneWidget);
    });

    testWidgets("should display ('Can't found the data') when result is empty",
        (WidgetTester test) async {
      when(() => mockMoviesSearchBloc.state).thenReturn(SearchMoviesData([]));
      when(() => mockTvSeriesSearchBloc.state)
          .thenReturn(SearchTvSeriesData([]));

      await test.pumpWidget(_makeTestableWidget(const SearchPage()));

      final errorText = find.text("Can't found the data");
      final textField = find.byKey(const Key('search-textfield'));
      final queryText = find.text('doraemon');

      await test.enterText(textField, 'doraemon');
      await test.testTextInput.receiveAction(TextInputAction.search);

      expect(errorText, findsOneWidget);
      expect(queryText, findsOneWidget);
    });

    testWidgets(
        'should not display anything when states is MoviesSearchError and TVSearchError',
        (WidgetTester test) async {
      when(() => mockMoviesSearchBloc.state).thenReturn(MoviesSearchError(''));
      when(() => mockTvSeriesSearchBloc.state)
          .thenReturn(TvSeriesSearchError(''));

      await test.pumpWidget(_makeTestableWidget(const SearchPage()));

      final errorText = find.byKey(const Key('search-error'));
      final textField = find.byKey(const Key('search-textfield'));
      final queryText = find.text('superman');

      await test.enterText(textField, 'superman');
      await test.testTextInput.receiveAction(TextInputAction.search);

      expect(errorText, findsOneWidget);
      expect(queryText, findsOneWidget);
    });
  });
}

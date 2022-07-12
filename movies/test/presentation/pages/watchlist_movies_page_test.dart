import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';


class MockMovieWatchlistBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

class MovieWatchlistEventFake extends Fake implements WatchlistMoviesEvent {}

class MovieWatchlistStateFake extends Fake implements WatchlistMoviesState {}

void main() {
  late final MockMovieWatchlistBloc mockWatchlistMoviesBloc;

  setUpAll(() {
    registerFallbackValue(MovieWatchlistEventFake());
    registerFallbackValue(MovieWatchlistStateFake());

    mockWatchlistMoviesBloc = MockMovieWatchlistBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesBloc>.value(
      value: mockWatchlistMoviesBloc,
      child: MaterialApp(home: body),
    );
  }

  group('Watchlist Movie Page', () {
    testWidgets(
        "should display CircularProgressIndicator when state is WatchlistMoviesLoading",
        (WidgetTester tester) async {
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoading());
      final circular = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget( WatchlistMoviesPage()));

      expect(circular, findsOneWidget);
    });

    testWidgets("should display ListView when state is WatchlistMoviesData",
        (WidgetTester tester) async {
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesHasData(testMovieList));
      final list = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget( WatchlistMoviesPage()));

      expect(list, findsOneWidget);
    });

    testWidgets(
        "should display Text('Failed') when state is WatchlistMoviesError",
        (WidgetTester tester) async {
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesError('Failed'));
      final errorText = find.text('Failed');

      await tester.pumpWidget(_makeTestableWidget( WatchlistMoviesPage()));
      expect(errorText, findsOneWidget);
    });

    testWidgets(
        "should display Text('Watchlist is Empty') when state is WatchlistMoviesEmpty",
        (WidgetTester tester) async {
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesEmpty());
      final empty = find.text("Watchlist is Empty");

      await tester.pumpWidget(_makeTestableWidget( WatchlistMoviesPage()));
      expect(empty, findsOneWidget);
    });
  });
}

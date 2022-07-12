import 'package:tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class WatchlistTvSeriesStateFake extends Fake
    implements WatchlistTvSeriesState {}

class WatchlistTvSeriesEventFake extends Fake
    implements WatchlistTvSeriesEvent {}

void main() {
  late final MockWatchlistTvSeriesBloc mockWatchlistTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistTvSeriesEventFake());
    registerFallbackValue(WatchlistTvSeriesStateFake());
    mockWatchlistTvSeriesBloc = MockWatchlistTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvSeriesBloc>.value(
      value: mockWatchlistTvSeriesBloc,
      child: MaterialApp(home: body),
    );
  }

  group('Watchlist Tv Series Page', () {
    testWidgets(
        "should display CircularProgressIndicator when state is WatchlistTvSeriesLoading",
        (WidgetTester tester) async {
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoading());
      final circular = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(const WatchlistTvSeriesPage()));

      expect(circular, findsOneWidget);
    });

    testWidgets("should display ListView when state is WatchlistTvSeriesData",
        (WidgetTester tester) async {
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesData(testTvSeriesList));
      final list = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvSeriesPage()));

      expect(list, findsOneWidget);
    });

    testWidgets(
        "should display Text('Failed') when state is WatchlistTvSeriesError",
        (WidgetTester tester) async {
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesError('Failed'));
      final errorText = find.text('Failed');

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvSeriesPage()));
      expect(errorText, findsOneWidget);
    });

    testWidgets(
        "should display Text('Watchlist is Empty') when state is WatchlistTvSeriesEmpty",
        (WidgetTester tester) async {
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesEmpty());
      final empty = find.text("Watchlist is Empty");

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvSeriesPage()));
      expect(empty, findsOneWidget);
    });
  });
}

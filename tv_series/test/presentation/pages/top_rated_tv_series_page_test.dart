import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_page_test.mocks.dart';

void main() {
  late final MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTvSeriesEventFake());
    registerFallbackValue(TopRatedTvSeriesStateFake());

    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockTopRatedTvSeriesBloc,
      child: MaterialApp(home: body),
    );
  }

  group('Top Rated Tv Series Page', () {
    testWidgets(
        'Should display CircularProgressIndicator when state is TopRatedTvSeriesLoading',
            (WidgetTester tester) async {
          when(() => mockTopRatedTvSeriesBloc.state)
              .thenReturn(TopRatedTvSeriesLoading());
          final circular = find.byType(CircularProgressIndicator);

          await tester.pumpWidget(_makeTestableWidget( TopRatedTvSeriesPage()));

          expect(circular, findsOneWidget);
        });

    testWidgets('Should display ListView when state is TopRatedTvSeriesData',
            (WidgetTester tester) async {
          when(() => mockTopRatedTvSeriesBloc.state)
              .thenReturn(TopRatedTvSeriesData(testTvSeriesList));
          final list = find.byType(ListView);

          await tester.pumpWidget(_makeTestableWidget( TopRatedTvSeriesPage()));

          expect(list, findsOneWidget);
        });

    testWidgets("Should display Text('Failed') when state is TopRatedTvSeriesError",
            (WidgetTester tester) async {
          when(() => mockTopRatedTvSeriesBloc.state)
              .thenReturn(TopRatedTvSeriesError('Failed'));
          final errorText = find.text('Failed');

          await tester.pumpWidget(_makeTestableWidget( TopRatedTvSeriesPage()));

          expect(errorText, findsOneWidget);
        });
  });
}

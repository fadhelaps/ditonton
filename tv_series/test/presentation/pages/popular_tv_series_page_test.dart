import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_page_test.mocks.dart';

void main() {
  late final MockPopularTvSeriesBloc mockPopularTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(PopularTvSeriesEventFake());
    registerFallbackValue(PopularTvSeriesStateFake());

    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockPopularTvSeriesBloc,
      child: MaterialApp(home: body),
    );
  }

  group('Popular TV Page', () {
    testWidgets(
        'Should display CircularProgressIndicator when state is PopularTvSeriesLoading',
            (WidgetTester tester) async {
          when(() => mockPopularTvSeriesBloc.state)
              .thenReturn(PopularTvSeriesLoading());
          final circular = find.byType(CircularProgressIndicator);

          await tester.pumpWidget(_makeTestableWidget( PopularTvSeriesPage()));

          expect(circular, findsOneWidget);
        });

    testWidgets('Should display ListView when state is PopularTvSeriesData',
            (WidgetTester tester) async {
          when(() => mockPopularTvSeriesBloc.state)
              .thenReturn(PopularTvSeriesHasData(testTvSeriesList));
          final list = find.byType(ListView);

          await tester.pumpWidget(_makeTestableWidget( PopularTvSeriesPage()));

          expect(list, findsOneWidget);
        });

    testWidgets("Should display Text('Failed') when state is PopularTvSeriesError",
            (WidgetTester tester) async {
          when(() => mockPopularTvSeriesBloc.state)
              .thenReturn(PopularTvSeriesError('Failed'));
          final errorText = find.text('Failed');

          await tester.pumpWidget(_makeTestableWidget( PopularTvSeriesPage()));

          expect(errorText, findsOneWidget);
        });
  });
}

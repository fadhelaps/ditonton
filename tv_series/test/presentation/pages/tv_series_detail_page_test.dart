import 'package:core/core.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_modify_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_status_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

void main() {
  late MockWatchlistTvSeriesStatusBloc mockWatchlistTvSeriesStatusBloc;
  late MockWatchlistTvSeriesModifyBloc mockWatchlistTvSeriesModifyBloc;
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistStatusStateFake());
    registerFallbackValue(WatchlistStatusEventFake());
    registerFallbackValue(WatchlistTvSeriesModifyStateFake());
    registerFallbackValue(WatchlistTvSeriesModifyEventFake());
    registerFallbackValue(TvSeriesDetailStateFake());
    registerFallbackValue(TvSeriesDetailEventFake());

    mockWatchlistTvSeriesStatusBloc = MockWatchlistTvSeriesStatusBloc();
    mockWatchlistTvSeriesModifyBloc = MockWatchlistTvSeriesModifyBloc();
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistStatusTvSeriesBloc>.value(
      value: mockWatchlistTvSeriesStatusBloc,
      child: BlocProvider<WatchListModifyTvSeriesBloc>.value(
        value: mockWatchlistTvSeriesModifyBloc,
        child: BlocProvider<TvSeriesDetailBloc>.value(
          value: mockTvSeriesDetailBloc,
          child: MaterialApp(
            home: body,
            theme: ThemeData.dark().copyWith(
              primaryColor: kRichBlack,
              scaffoldBackgroundColor: kRichBlack,
              textTheme: kTextTheme,
              colorScheme: kColorScheme.copyWith(
                  secondary: kMikadoYellow
              ),
            ),
          ),
        ),
      ),
    );
  }

  const id = 1;

  group('Detail Tv Series Page', () {
    testWidgets(
        'Should display CircularProgressIndicator when state is TvSeriesDetailLoading',
            (WidgetTester tester) async {
          when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailLoading());
          when(() => mockWatchlistTvSeriesStatusBloc.state)
              .thenReturn(WatchlistStatusTvSeriesEmpty());
          when(() => mockWatchlistTvSeriesModifyBloc.state)
              .thenReturn(WatchListModifyTvSeriesEmpty());
          final circular = find.byType(CircularProgressIndicator);

          await tester.pumpWidget(_makeTestableWidget( TvSeriesDetailPage(id: id)));

          expect(circular, findsOneWidget);
        });

    testWidgets('Should display Text when state is TvSeriesDetailError',
            (WidgetTester tester) async {
          when(() => mockTvSeriesDetailBloc.state)
              .thenReturn(TvSeriesDetailError('Failed'));
          when(() => mockWatchlistTvSeriesStatusBloc.state)
              .thenReturn(WatchlistStatusTvSeriesEmpty());
          when(() => mockWatchlistTvSeriesModifyBloc.state)
              .thenReturn(WatchListModifyTvSeriesEmpty());
          final errorText = find.text('Failed');

          await tester.pumpWidget(_makeTestableWidget( TvSeriesDetailPage(id: id)));

          expect(errorText, findsOneWidget);
        });

    testWidgets(
        'Should display Icon Check when state is TvSeriesDetailData and TvSeriesStatusState(true)',
            (WidgetTester tester) async {
          when(() => mockTvSeriesDetailBloc.state)
              .thenReturn(TvSeriesDetailData(testTvSeriesDetail, testTvSeriesList));
          when(() => mockWatchlistTvSeriesStatusBloc.state)
              .thenReturn(TvSeriesStatusState(true));
          when(() => mockWatchlistTvSeriesModifyBloc.state)
              .thenReturn(WatchListModifyTvSeriesEmpty());
          final iconCheck = find.byIcon(Icons.check);

          await tester.pumpWidget(_makeTestableWidget( TvSeriesDetailPage(id: id)));

          expect(iconCheck, findsOneWidget);
        });

    testWidgets(
        'Should display Icon Add when state is TvSeriesDetailData and TvSeriesStatusState(false)',
            (WidgetTester tester) async {
          when(() => mockTvSeriesDetailBloc.state)
              .thenReturn(TvSeriesDetailData(testTvSeriesDetail, testTvSeriesList));
          when(() => mockWatchlistTvSeriesStatusBloc.state)
              .thenReturn(TvSeriesStatusState(false));
          when(() => mockWatchlistTvSeriesModifyBloc.state)
              .thenReturn(WatchListModifyTvSeriesEmpty());
          final iconAdd = find.byIcon(Icons.add);

          await tester.pumpWidget(_makeTestableWidget( TvSeriesDetailPage(id: id)));

          expect(iconAdd, findsOneWidget);
        });
  });
}

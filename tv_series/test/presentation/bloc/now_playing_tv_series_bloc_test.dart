import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv_series.dart';
import 'package:tv_series/presentation/bloc/now_playing_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries])
void main() {
  late NowPlayingTvSeriesBloc nowPlayingTvSeriesBloc;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    nowPlayingTvSeriesBloc = NowPlayingTvSeriesBloc(getNowPlayingTvSeries: mockGetNowPlayingTvSeries);
  });

  group(
    'Now Playing Tv Series',
    () {
      test('initial state should be on page', () {
        expect(nowPlayingTvSeriesBloc.state, NowPlayingTvSeriesEmpty());
      });

      blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
        'should emit [Loading, Data] when data is gotten successfully',
        build: () {
          when(mockGetNowPlayingTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          return nowPlayingTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchNowPlayingTvSeries().props,
        expect: () => [NowPlayingTvSeriesLoading(), NowPlayingTvSeriesHasData(testTvSeriesList)],
      );

      blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
        'should emit [Loading, Error] when data is gotten is unsuccessful',
        build: () {
          when(mockGetNowPlayingTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return nowPlayingTvSeriesBloc;
        },
        act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
        wait: const Duration(milliseconds: 500),
        verify: (_) => FetchNowPlayingTvSeries().props,
        expect: () => [NowPlayingTvSeriesLoading(), NowPlayingTvSeriesError('Failed')],
      );
    },
  );
}

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv_series.dart';

class NowPlayingTvSeriesBloc extends Bloc<NowPlayingTvSeriesEvent, NowPlayingTvSeriesState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  NowPlayingTvSeriesBloc({
    required this.getNowPlayingTvSeries,
  }) : super(NowPlayingTvSeriesEmpty()) {
    on<FetchNowPlayingTvSeries>(_fetchNowPlayingTvSeries);
  }

  void _fetchNowPlayingTvSeries(FetchNowPlayingTvSeries fetchNowPlayingTvSeries,
      Emitter<NowPlayingTvSeriesState> emit) async {
    emit(NowPlayingTvSeriesLoading());
    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) => emit(NowPlayingTvSeriesError(failure.message)),
      (data) => emit(NowPlayingTvSeriesHasData(data)),
    );
  }
}

abstract class NowPlayingTvSeriesState extends Equatable {}

class NowPlayingTvSeriesEmpty extends NowPlayingTvSeriesState {
  @override
  List<Object> get props => [];
}

class NowPlayingTvSeriesLoading extends NowPlayingTvSeriesState {
  @override
  List<Object> get props => [];
}

class NowPlayingTvSeriesError extends NowPlayingTvSeriesState {
  final String message;

  NowPlayingTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingTvSeriesHasData extends NowPlayingTvSeriesState {
  final List<TvSeries> tvSeries;

  NowPlayingTvSeriesHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

abstract class NowPlayingTvSeriesEvent extends Equatable {}

class FetchNowPlayingTvSeries extends NowPlayingTvSeriesEvent {
  @override
  List<Object> get props => [];
}

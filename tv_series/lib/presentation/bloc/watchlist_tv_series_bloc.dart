import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc({
    required this.getWatchlistTvSeries,
  }) : super(WatchlistTvSeriesEmpty()) {
    on<FetchWatchlistTvSeries>(_fetchWatchlistTvSeries);
  }

  void _fetchWatchlistTvSeries(FetchWatchlistTvSeries fetchWatchlistTvSeries,
      Emitter<WatchlistTvSeriesState> emit) async {
    emit(WatchlistTvSeriesLoading());
    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) => emit(WatchlistTvSeriesError(failure.message)),
      (data) => data.isNotEmpty
          ? emit(WatchlistTvSeriesData(data))
          : emit(WatchlistTvSeriesEmpty()),
    );
  }
}

abstract class WatchlistTvSeriesState extends Equatable {}

class WatchlistTvSeriesEmpty extends WatchlistTvSeriesState {
  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {
  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvSeriesData extends WatchlistTvSeriesState {
  final List<TvSeries> tvSeries;

  WatchlistTvSeriesData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

abstract class WatchlistTvSeriesEvent extends Equatable {}

class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {
  @override
  List<Object> get props => [];
}

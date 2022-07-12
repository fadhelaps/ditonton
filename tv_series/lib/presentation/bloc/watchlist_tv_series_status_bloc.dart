import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';

class WatchlistStatusTvSeriesBloc extends Bloc<WatchlistStatusTvSeriesEvent, WatchlistStatusTvSeriesState> {
  final GetTvSeriesWatchListStatus getTvSeriesWatchlistStatus;

  WatchlistStatusTvSeriesBloc({required this.getTvSeriesWatchlistStatus,
  }) : super(WatchlistStatusTvSeriesEmpty()) {
    on<FetchWatchlistStatusTvSeries>(_fetchWatchlistStatusTvSeries);
  }

  void _fetchWatchlistStatusTvSeries(FetchWatchlistStatusTvSeries fetchWatchlistStatusTvSeries,
      Emitter<WatchlistStatusTvSeriesState> emit) async {
    final result = await getTvSeriesWatchlistStatus.execute(fetchWatchlistStatusTvSeries.id);
    emit(TvSeriesStatusState(result));
  }
}

abstract class WatchlistStatusTvSeriesState extends Equatable {}

class WatchlistStatusTvSeriesEmpty extends WatchlistStatusTvSeriesState {
  @override
  List<Object> get props => [];
}

class TvSeriesStatusState extends WatchlistStatusTvSeriesState {
  final bool isAddedToWatchlist;

  TvSeriesStatusState(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

abstract class WatchlistStatusTvSeriesEvent extends Equatable {}

class FetchWatchlistStatusTvSeries extends WatchlistStatusTvSeriesEvent {
  final int id;

  FetchWatchlistStatusTvSeries(this.id);

  @override
  List<Object> get props => [id];
}


import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';

class WatchListModifyTvSeriesBloc extends Bloc<WatchListModifyTvSeriesEvent, WatchListModifyTvSeriesState> {

  final SaveTvSeriesWatchlist saveWatchlistTvSeries;
  final RemoveTvSeriesWatchlist removeWatchlistTvSeries;

  WatchListModifyTvSeriesBloc({
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(WatchListModifyTvSeriesEmpty()) {
    on<AddTvSeries>(_addTvSeriesWatchlist);
    on<RemoveTvSeries>(_removeTvSeriesWatchlist);
  }

  void _addTvSeriesWatchlist(
      AddTvSeries addTvSeries,
      Emitter<WatchListModifyTvSeriesState> emit
    ) async {
      emit(WatchListModifyTvSeriesLoading());
      final result = await saveWatchlistTvSeries.execute(addTvSeries.tvSeriesDetail);

      result.fold(
        (failure) => emit(WatchListModifyTvSeriesError(failure.message)),
        (success) => emit(AddedTvSeries(success)),
      );
    }

  void _removeTvSeriesWatchlist(
      RemoveTvSeries removeTvSeries,
      Emitter<WatchListModifyTvSeriesState> emit
    ) async {
      emit(WatchListModifyTvSeriesLoading());
      final result = await removeWatchlistTvSeries.execute(removeTvSeries.tvSeriesDetail);

      result.fold(
        (failure) => emit(WatchListModifyTvSeriesError(failure.message)),
        (success) => emit(TvSeriesRemoved(success)),
      );
    }
}

abstract class WatchListModifyTvSeriesState extends Equatable {}

class WatchListModifyTvSeriesEmpty extends WatchListModifyTvSeriesState {
  @override
  List<Object> get props => [];
}

class WatchListModifyTvSeriesLoading extends WatchListModifyTvSeriesState {
  @override
  List<Object> get props => [];
}

class AddedTvSeries extends WatchListModifyTvSeriesState {
  final String message;

  AddedTvSeries(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesRemoved extends WatchListModifyTvSeriesState {
  final String message;

  TvSeriesRemoved(this.message);

  @override
  List<Object> get props => [message];
}

class WatchListModifyTvSeriesError extends WatchListModifyTvSeriesState {
  final String message;

  WatchListModifyTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class WatchListModifyTvSeriesEvent extends Equatable {}

class AddTvSeries extends WatchListModifyTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  AddTvSeries(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveTvSeries extends WatchListModifyTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  RemoveTvSeries(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}


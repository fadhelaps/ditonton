import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

import 'package:search/domain/search_tv_series.dart';

class TvSeriesSearchBloc extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries tvSeries;

  TvSeriesSearchBloc({required this.tvSeries}) : super(TvSeriesSearchEmpty()) {
    on<OnTvSeriesQueryChanged>((event, emit) async {
      final dataQuery = event.query;

      emit(TvSeriesSearchLoading());
      final dataResult = await tvSeries.execute(dataQuery);

      dataResult.fold((failure) {
        emit(TvSeriesSearchError(failure.message));
      }, (data) {
        emit(SearchTvSeriesData(data));
      });
    }, transformer: _debounceTvSeries(const Duration(milliseconds: 500)));
  }

  EventTransformer<OnTvSeriesQueryChanged> _debounceTvSeries<OnTvSeriesQueryChanged>(
      Duration dur) {
    return (events, mapper) => events.debounceTime(dur).switchMap(mapper);
  }
}

abstract class TvSeriesSearchState extends Equatable {}

class TvSeriesSearchEmpty extends TvSeriesSearchState {
  @override
  List<Object> get props => [];
}

class TvSeriesSearchLoading extends TvSeriesSearchState {
  @override
  List<Object> get props => [];
}

class TvSeriesSearchError extends TvSeriesSearchState {
  final String message;

  TvSeriesSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchTvSeriesData extends TvSeriesSearchState {
  final List<TvSeries> result;

  SearchTvSeriesData(this.result);

  @override
  List<Object> get props => [result];
}

abstract class TvSeriesSearchEvent extends Equatable {}

class OnTvSeriesQueryChanged extends TvSeriesSearchEvent {
  final String query;

  OnTvSeriesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}


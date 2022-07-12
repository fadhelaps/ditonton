import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';

class PopularTvSeriesBloc extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc({
    required this.getPopularTvSeries,
  }) : super(PopularTvSeriesEmpty()) {
    on<FetchPopularTvSeries>(_fetchPopularTvSeries);
  }

  void _fetchPopularTvSeries(
      FetchPopularTvSeries fetchPopularTvSeries,
      Emitter<PopularTvSeriesState> emit) async {
    emit(PopularTvSeriesLoading());
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(PopularTvSeriesError(failure.message)),
      (data) => emit(PopularTvSeriesHasData(data)),
    );
  }
}

abstract class PopularTvSeriesState extends Equatable {}

class PopularTvSeriesEmpty extends PopularTvSeriesState {
  @override
  List<Object> get props => [];
}

class PopularTvSeriesLoading extends PopularTvSeriesState {
  @override
  List<Object> get props => [];
}

class PopularTvSeriesError extends PopularTvSeriesState {
  final String message;

  PopularTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTvSeriesHasData extends PopularTvSeriesState {
  final List<TvSeries> tvSeries;

  PopularTvSeriesHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

abstract class PopularTvSeriesEvent extends Equatable {}

class FetchPopularTvSeries extends PopularTvSeriesEvent {
  @override
  List<Object> get props => [];
}


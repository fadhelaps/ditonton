import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';

class TopRatedTvSeriesBloc extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc({
    required this.getTopRatedTvSeries,
  }) : super(TopRatedTvSeriesEmpty()) {
    on<FetchTopRatedTvSeries>(_fetchTopRatedTvSeries);
  }

  void _fetchTopRatedTvSeries(
      FetchTopRatedTvSeries fetchTopRatedTvSeries,
      Emitter<TopRatedTvSeriesState> emit) async {
    emit(TopRatedTvSeriesLoading());
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(TopRatedTvSeriesError(failure.message)),
      (data) => emit(TopRatedTvSeriesData(data)),
    );
  }
}

abstract class TopRatedTvSeriesState extends Equatable {}

class TopRatedTvSeriesEmpty extends TopRatedTvSeriesState {
  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {
  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesError extends TopRatedTvSeriesState {
  final String message;

  TopRatedTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTvSeriesData extends TopRatedTvSeriesState {
  final List<TvSeries> tvSeries;

  TopRatedTvSeriesData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

abstract class TopRatedTvSeriesEvent extends Equatable {}

class FetchTopRatedTvSeries extends TopRatedTvSeriesEvent {
  @override
  List<Object> get props => [];
}

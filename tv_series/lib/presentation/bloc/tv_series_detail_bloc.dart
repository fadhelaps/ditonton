import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
  }) : super((TvSeriesDetailEmpty())) {
    on<FetchTvSeriesDetail>(_fetchTvSeriesDetail);
  }

  void _fetchTvSeriesDetail(
      FetchTvSeriesDetail fetchTvSeriesDetail,
      Emitter<TvSeriesDetailState> emit) async {
    emit(TvSeriesDetailLoading());
    final resultDetail = await getTvSeriesDetail.execute(fetchTvSeriesDetail.id);
    final resultRecommendations = await getTvSeriesRecommendations.execute(fetchTvSeriesDetail.id);
    resultDetail.fold((failure) => emit(TvSeriesDetailError(failure.message)),
        (tvSeriesDetail) {
      emit(TvSeriesDetailLoading());
      resultRecommendations.fold(
        (failure) => emit(TvSeriesDetailError(failure.message)),
        (tvSeriesRecommendations) => emit(
          TvSeriesDetailData(tvSeriesDetail, tvSeriesRecommendations),
        ),
      );
    });
  }
}

abstract class TvSeriesDetailState extends Equatable {}

class TvSeriesDetailEmpty extends TvSeriesDetailState {
  @override
  List<Object> get props => [];
}

class TvSeriesDetailLoading extends TvSeriesDetailState {
  @override
  List<Object> get props => [];
}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  TvSeriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesDetailData extends TvSeriesDetailState {
  final TvSeriesDetail tvSeriesDetail;
  final List<TvSeries> tvSeries;

  TvSeriesDetailData(this.tvSeriesDetail, this.tvSeries);

  @override
  List<Object> get props => [tvSeriesDetail, tvSeries];
}

abstract class TvSeriesDetailEvent extends Equatable {}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  FetchTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}


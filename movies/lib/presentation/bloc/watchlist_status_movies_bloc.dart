import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';

class WatchListStatusMoviesBloc extends Bloc<WatchListStatusEvent, WatchListStatusMoviesState> {
  final GetMoviesWatchListStatus getMoviesWatchListStatus;

  WatchListStatusMoviesBloc({required this.getMoviesWatchListStatus,
  }) : super(WatchListStatusMoviesEmpty()) {
    on<FetchWatchListStatusMovies>(_fetchWatchListStatusMovies);
  }

  void _fetchWatchListStatusMovies(FetchWatchListStatusMovies fetchWatchListStatusMovies,
      Emitter<WatchListStatusMoviesState> emit) async {
    final result = await getMoviesWatchListStatus.execute(fetchWatchListStatusMovies.id);
    emit(MoviesStatusState(result));
  }
}

abstract class WatchListStatusMoviesState extends Equatable {}

class WatchListStatusMoviesEmpty extends WatchListStatusMoviesState {
  @override
  List<Object> get props => [];
}

class MoviesStatusState extends WatchListStatusMoviesState {
  final bool isAddedToWatchlist;

  MoviesStatusState(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

abstract class WatchListStatusEvent extends Equatable {}

class FetchWatchListStatusMovies extends WatchListStatusEvent {
  final int id;

  FetchWatchListStatusMovies(this.id);

  @override
  List<Object> get props => [id];
}

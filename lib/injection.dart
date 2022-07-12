import 'dart:io';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:http/io_client.dart';
import 'package:get_it/get_it.dart';

import 'package:movies/data/datasources/movie_local_data_source.dart';
import 'package:tv_series/data/datasources/tv_series_local_data_source.dart';

import 'package:movies/data/datasources/movie_remote_data_source.dart';
import 'package:tv_series/data/datasources/tv_series_remote_data_source.dart';

import 'package:movies/data/repositories/movie_repository_impl.dart';
import 'package:tv_series/data/repositories/tv_series_repository_impl.dart';

import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';

import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';

import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv_series.dart';

import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';

import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';

import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';

import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';

import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';

import 'package:movies/domain/usecases/save_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';

import 'package:movies/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing_tv_series_bloc.dart';

import 'package:movies/presentation/bloc/movies_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_bloc.dart';

import 'package:movies/presentation/bloc/popular_movie_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';

import 'package:movies/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';

import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_bloc.dart';

import 'package:movies/presentation/bloc/watchlist_modify_movies_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_modify_tv_series_bloc.dart';

import 'package:movies/presentation/bloc/watchlist_status_movies_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_status_bloc.dart';

import 'package:search/domain/search_movies.dart';
import 'package:search/domain/search_tv_series.dart';

import 'package:search/presentation/bloc/movie/search_bloc.dart';
import 'package:search/presentation/bloc/tv_series/search_bloc.dart';

final locator = GetIt.instance;

void init(HttpClient client) {
  // bloc
  locator.registerFactory(() => NowPlayingMoviesBloc(getNowPlayingMovies: locator()));
  locator.registerFactory(() => NowPlayingTvSeriesBloc(getNowPlayingTvSeries: locator()));

  locator.registerFactory(() => PopularMoviesBloc(getPopularMovies: locator()));
  locator.registerFactory(() => PopularTvSeriesBloc(getPopularTvSeries: locator()));

  locator.registerFactory(() => TopRatedMoviesBloc(getTopRatedMovies: locator()));
  locator.registerFactory(() => TopRatedTvSeriesBloc(getTopRatedTvSeries: locator()));

  locator.registerFactory(() => MoviesDetailBloc(getMovieDetail: locator(), getMovieRecommendations: locator()));
  locator.registerFactory(() => TvSeriesDetailBloc(getTvSeriesDetail: locator(), getTvSeriesRecommendations: locator()));

  locator.registerFactory(() => WatchListModifyMoviesBloc(saveMoviesWatchlist: locator(), removeMoviesWatchlist: locator()));
  locator.registerFactory(() => WatchListModifyTvSeriesBloc(saveWatchlistTvSeries: locator(), removeWatchlistTvSeries: locator()));

  locator.registerFactory(() => WatchListStatusMoviesBloc(getMoviesWatchListStatus: locator()));
  locator.registerFactory(() => WatchlistStatusTvSeriesBloc(getTvSeriesWatchlistStatus: locator()));

  locator.registerFactory(() => WatchlistMoviesBloc(getWatchlistMovies: locator()));
  locator.registerFactory(() => WatchlistTvSeriesBloc(getWatchlistTvSeries: locator()));

  locator.registerFactory(() => MoviesSearchBloc(movies: locator()));
  locator.registerFactory(() => TvSeriesSearchBloc(tvSeries: locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));

  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));

  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));

  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));

  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));

  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));

  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  locator.registerLazySingleton(() => GetMoviesWatchListStatus(locator()));
  locator.registerLazySingleton(() => GetTvSeriesWatchListStatus(locator()));

  locator.registerLazySingleton(() => SaveMoviesWatchlist(locator()));
  locator.registerLazySingleton(() => SaveTvSeriesWatchlist(locator()));

  locator.registerLazySingleton(() => RemoveMoviesWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvSeriesWatchlist(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<TvSeriesRepository>(
        () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
          () => TvSeriesRemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
          () => TvSeriesLocalDataSourceImpl(DatabaseHelperTvSeries: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => IOClient(client));
}

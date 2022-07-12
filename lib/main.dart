import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:ditonton/injection.dart' as ditonton;

import 'package:about/about_page.dart';

import 'package:core/utils/ssl.dart';
import 'package:core/core.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:core/presentation/pages/watchlist_page.dart';

import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';

import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';

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

import 'package:search/presentation/bloc/movie/search_bloc.dart';
import 'package:search/presentation/bloc/tv_series/search_bloc.dart';
import 'package:search/presentation/page/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  ditonton.init(await getHttpClient());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => ditonton.locator<MoviesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<TvSeriesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<NowPlayingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<NowPlayingTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<PopularTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<TopRatedTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<WatchlistMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<WatchlistTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<WatchListModifyMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<WatchListModifyTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<WatchListStatusMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<WatchlistStatusTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<MoviesSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => ditonton.locator<TvSeriesSearchBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        initialRoute: route_home,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case route_home:
              return MaterialPageRoute(builder: (_) => HomePage());
            case route_search:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case route_watchlist:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case route_about:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case route_popular_movie:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case route_popular_tv_series:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case route_top_rated_movie:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case route_top_rated_tv_series:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case route_detail_movie:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case route_detail_tv_series:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:movies/presentation/pages/home_movie_page.dart';
import 'package:movies/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:movies/presentation/bloc/popular_movie_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movie_bloc.dart';

import 'package:tv_series/presentation/pages/home_tv_series_page.dart';
import 'package:tv_series/presentation/bloc/now_playing_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';

import '../widgets/custom_drawers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<NowPlayingMoviesBloc>(context)
          .add(FetchNowPlayingMovies());
      BlocProvider.of<PopularMoviesBloc>(context).add(FetchPopularMovies());
      BlocProvider.of<TopRatedMoviesBloc>(context).add(FetchTopRatedMovies());

      BlocProvider.of<NowPlayingTvSeriesBloc>(context).add(FetchNowPlayingTvSeries());
      BlocProvider.of<PopularTvSeriesBloc>(context).add(FetchPopularTvSeries());
      BlocProvider.of<TopRatedTvSeriesBloc>(context).add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      content: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: const Text('Ditonton'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, route_search);
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HomeMoviePage(),
                const HomeTvSeriesPage(),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

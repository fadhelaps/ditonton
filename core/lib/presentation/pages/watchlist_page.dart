import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/watchlist_tv_series_page.dart';


class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  _WatchlistPage createState() => _WatchlistPage();
}

class _WatchlistPage extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<WatchlistTvSeriesBloc>(context).add(FetchWatchlistTvSeries()));
    Future.microtask(() => BlocProvider.of<WatchlistMoviesBloc>(context)
        .add(FetchWatchlistMovies()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    BlocProvider.of<WatchlistTvSeriesBloc>(context).add(FetchWatchlistTvSeries());
    BlocProvider.of<WatchlistMoviesBloc>(context).add(FetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            indicatorColor: kMikadoYellow,
            tabs: [
              Tab(icon: Icon(Icons.movie)),
              Tab(icon: Icon(Icons.tv)),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: TabBarView(
            children: [WatchlistMoviesPage(), WatchlistTvSeriesPage()],
          ),
        ),
      ),
    );
  }
}

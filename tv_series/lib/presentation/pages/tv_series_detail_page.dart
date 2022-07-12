import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:movies/domain/entities/genre.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/presentation/bloc/watchlist_modify_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_status_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final int id;

  // ignore: use_key_in_widget_constructors
  const TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TvSeriesDetailBloc>(context).add(FetchTvSeriesDetail(widget.id));
      BlocProvider.of<WatchlistStatusTvSeriesBloc>(context).add(FetchWatchlistStatusTvSeries(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WatchListModifyTvSeriesBloc, WatchListModifyTvSeriesState>(
      listenWhen: (context, state) =>
      state is AddedTvSeries ||
          state is TvSeriesRemoved ||
          state is WatchListModifyTvSeriesError,
      listener: (context, state) {
        if (state is AddedTvSeries) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is TvSeriesRemoved) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is WatchListModifyTvSeriesError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
          builder: (context, data) =>
              BlocBuilder<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
                  builder: (context, status) {
                    if (data is TvSeriesDetailData && status is TvSeriesStatusState) {
                      return SafeArea(
                          child: DetailContent(
                              data.tvSeriesDetail, data.tvSeries, status.isAddedToWatchlist));
                    } else if (data is TvSeriesDetailError) {
                      return Text(data.message);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
        ),
      ),
    );

  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tvSeries, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name!,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (isAddedWatchlist) {
                                  context
                                      .read<WatchListModifyTvSeriesBloc>()
                                      .add(RemoveTvSeries(tvSeries));
                                  context
                                      .read<WatchlistStatusTvSeriesBloc>()
                                      .add(FetchWatchlistStatusTvSeries(tvSeries.id));
                                } else {
                                  context
                                      .read<WatchListModifyTvSeriesBloc>()
                                      .add(AddTvSeries(tvSeries));
                                  context
                                      .read<WatchlistStatusTvSeriesBloc>()
                                      .add(FetchWatchlistStatusTvSeries(tvSeries.id));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tvSeries.genres!),
                            ),
                            Text('Total Seasons: ${tvSeries.numberOfSeasons}'),
                            Text('Total Episodes: ${tvSeries.numberOfEpisodes}'),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage! / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview!,
                            ),
                        SizedBox(height: 16),
                        (recommendations.isNotEmpty)
                            ? Text(
                          'Recommendations',
                          style: kHeading6,
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final tvSeries = recommendations[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      route_detail_tv_series,
                                      arguments: tvSeries.id,
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: BASE_IMAGE_URL +
                                          '${tvSeries.posterPath}',
                                      placeholder: (context, url) =>
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: recommendations.length,
                          ),
                        ),
                        ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
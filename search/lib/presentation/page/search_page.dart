import 'package:core/core.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/movie/search_bloc.dart';
import 'package:search/presentation/bloc/tv_series/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies and TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: Key('search-textfield'),
              onChanged: (query) {
                context
                    .read<MoviesSearchBloc>()
                    .add(OnMoviesQueryChanged(query));
                context
                    .read<TvSeriesSearchBloc>()
                    .add(OnTvSeriesQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<MoviesSearchBloc, MoviesSearchState>(
              builder: (context, movieObject) =>
                  BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
                      builder: (context, tvSeriesObject) {
                if (movieObject is MoviesSearchLoading &&
                    tvSeriesObject is TvSeriesSearchLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (tvSeriesObject is SearchTvSeriesData &&
                    movieObject is SearchMoviesData) {
                  final List<dynamic> result = [
                    ...movieObject.result,
                    ...tvSeriesObject.result
                  ];
                  return Expanded(
                    child: (result.isNotEmpty)
                        ? ListView.builder(
                            key: const Key('search-listview'),
                            itemBuilder: (_, index) => (result[index] is Movie)
                                ? MovieCard(result[index])
                                : TvSeriesCard(result[index]),
                            itemCount: result.length,
                          )
                        : const Center(
                            child: Text(
                              "Can't found the data",
                            ),
                          ),
                  );
                } else {
                  return const SizedBox(key: Key('search-error'));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:movies/domain/entities/genre.dart';
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

//dummy data tv series
final testTvSeries = TvSeries(
  backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
  firstAirDate: '2021-09-17',
  genreIds: [10759, 9648, 18],
  id: 9340,
  name: 'Squid Game',
  originalLanguage: 'ko',
  originalName: '오징어 게임',
  overview:
      "Hundreds of cash-strapped players accept a strange invitation to compete in children's games—with high stakes. But, a tempting prize awaits the victor.",
  popularity: 60.441,
  posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
  voteAverage: 7.8,
  voteCount: 7893,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  homePage: "https://google.com",
  id: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  status: 'Status',
  voteAverage: 1,
  voteCount: 1,
  episodeRunTime: [50, 50],
  firstAirDate: 'firstAirDate',
  name: 'name',
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  popularity: 1,
  type: 'type',
  originalName: 'originalName',
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'name': 'name',
  'overview': 'overview',
  'posterPath': 'posterPath',
};

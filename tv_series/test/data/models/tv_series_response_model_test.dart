import 'dart:convert';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../json_reader.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    backdropPath: '/path.jpg',
    firstAirDate: '2020-05-05',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'Name',
    originalLanguage: "Original Language",
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  const tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2020-05-05",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "name": "Name",
            "original_language": "Original Language",
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "vote_average": 1.0,
            "vote_count": 1,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}

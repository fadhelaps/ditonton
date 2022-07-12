import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/io_client.dart';

@GenerateMocks([
  MovieRepository,
  TvSeriesRepository,
], customMocks: [
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}

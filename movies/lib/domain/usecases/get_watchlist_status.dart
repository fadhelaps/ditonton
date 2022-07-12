import 'package:movies/domain/repositories/movie_repository.dart';

class GetMoviesWatchListStatus {
  final MovieRepository repository;

  GetMoviesWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guided_doing_movie_challenge/model/movie.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  // final config = ref.read(environmentConfigProvider);
  return MovieService(Dio());
});

class MovieService {
  MovieService(this._dio);

  final Dio _dio;

  Future<List<Movie>> getMovies(String search) async {
    final response = await _dio.get(
        "https://us-central1-fireshape-firebase-flutter.cloudfunctions.net/omdbapiSearch/?search=${search == "" ? "dark" : search}");

    final test = response.data['Search'];
    final results = List<Map<String, dynamic>>.from(test);
    List<Movie> movies = results
        .map((movieDate) => Movie.fromMap(movieDate))
        .toList(growable: false);
    return movies;
  }

  Future<Movie> getMovie(String id) async {
    final response = await _dio.get(
        "https://us-central1-fireshape-firebase-flutter.cloudfunctions.net/omdbapiMovie/?movie=$id");
    final movie = Movie.fromMap(response.data);

    return movie;
  }
}

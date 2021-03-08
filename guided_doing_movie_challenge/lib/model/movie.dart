import 'dart:convert';

class Movie {
  String title;
  String poster;
  String description;
  String genre;
  String id;

  Movie({
    this.title,
    this.poster,
    this.id,
    this.genre,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Poster': poster,
      'Plot': description,
      'Genre': genre,
      'imdbID': id,
    };
  }

  // String get fullImageUrl => 'https://image.tmdb.org/t/p/w200$poster';

  factory Movie.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Movie(
      title: map['Title'],
      poster: map['Poster'],
      description: map['Plot'],
      genre: map['Genre'],
      id: map['imdbID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));

  @override
  String toString() => 'Movie(title: $title, posterPath: $poster)';
}

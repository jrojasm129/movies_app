import 'dart:convert';

const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

class Movie {

    bool adult;
    String? backdropPath;
    int id;
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    DateTime? releaseDate;
    String title;
    bool video;
    double voteAverage;
    int voteCount;
    String? heroTag;

    Movie({
        required this.adult,
        this.backdropPath,
        required this.id,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        required this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
        this.heroTag
    });

    factory Movie.fromJson(String str) => Movie.fromMap(json.decode(str));

    factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.tryParse(json["release_date"]??'') != null
        ? DateTime.parse(json["release_date"])
        : null,
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
    );


    String get fullBackdropPath {
      return backdropPath != null
     ? '$_imageBaseUrl$backdropPath' 
     : 'https://i.stack.imgur.com/GNhxO.png';
    }

    String get fullPosterPath {
     return posterPath != null
     ? '$_imageBaseUrl$posterPath' 
     : 'https://i.stack.imgur.com/GNhxO.png';
    }

}
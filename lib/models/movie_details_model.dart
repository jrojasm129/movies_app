import 'dart:convert';
import 'package:movies_info/models/genre_model.dart';
import 'package:movies_info/models/video_model.dart';

import 'character_model.dart';

const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

class MovieDetailsModel {
    MovieDetailsModel({
        required this.adult,
        this.backdropPath,
        required this.genres,
        required this.id,
        required this.originalTitle,
        this.overview,
        required this.popularity,
        this.posterPath,
        this.releaseDate,
        required this.status,
        this.tagline,
        required this.title,
        required this.voteAverage,
        required this.voteCount,
        required this.videos,
        required this.credits,
    });

    bool adult;
    String? backdropPath;
    List<Genre> genres;
    int id;
    String originalTitle;
    String? overview;
    double popularity;
    String? posterPath;
    DateTime? releaseDate;
    String status;
    String? tagline;
    String title;
    double voteAverage;
    int voteCount;
    _Videos videos;
    _Credits credits;

    factory MovieDetailsModel.fromJson(String str) => MovieDetailsModel.fromMap(json.decode(str));

    factory MovieDetailsModel.fromMap(Map<String, dynamic> json) => MovieDetailsModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.tryParse(json["release_date"]??'') != null
        ? DateTime.parse(json["release_date"])
        : null,
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        videos: _Videos.fromMap(json["videos"]),
        credits: _Credits.fromMap(json["credits"]),
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

class _Videos {
    _Videos({
        required this.results,
    });

    List<VideoModel> results;

    // factory _Videos.fromJson(String str) => _Videos.fromMap(json.decode(str));

    factory _Videos.fromMap(Map<String, dynamic> json) => _Videos(
        results: List<VideoModel>.from(json["results"].map((x) => VideoModel.fromMap(x))),
    );

}

class _Credits {
    _Credits({
        required this.cast,
        required this.crew,
    });

    List<CharacterModel> cast;
    List<CharacterModel> crew;

    // factory _Credits.fromJson(String str) => _Credits.fromMap(json.decode(str));

    factory _Credits.fromMap(Map<String, dynamic> json) => _Credits(
        cast: List<CharacterModel>.from(json["cast"].map((x) => CharacterModel.fromMap(x))),
        crew: List<CharacterModel>.from(json["crew"].map((x) => CharacterModel.fromMap(x))),
    );

}




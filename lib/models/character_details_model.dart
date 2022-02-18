
import 'dart:convert';

import 'package:movies_info/models/movie_model.dart';

const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

class CharacterDetailsModel {
    CharacterDetailsModel({
        required this.adult,
        required this.biography,
        this.birthday,
        required this.deathday,
        required this.gender,
        required this.id,
        required this.name,
        required this.placeOfBirth,
        required this.popularity,
        this.profilePath,
        required this.movieCredits,
    });
 
    bool adult;
    String biography;
    DateTime? birthday;
    dynamic deathday;
    String gender;
    int id;
    String name;
    String placeOfBirth;
    double popularity;
    String? profilePath;
    MovieCredits movieCredits;

    factory CharacterDetailsModel.fromJson(String str) => CharacterDetailsModel.fromMap(json.decode(str));

    factory CharacterDetailsModel.fromMap(Map<String, dynamic> json) => CharacterDetailsModel(
        adult: json["adult"],
        biography: json["biography"],
        birthday:  DateTime.tryParse(json["birthday"]??'') != null
        ? DateTime.parse(json["birthday"])
        : null,
        deathday: json["deathday"],
        gender: _parseGender(json["gender"]),
        id: json["id"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"]??'',
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
        movieCredits: MovieCredits.fromMap(json["movie_credits"]),
    );

        static String _parseGender(int? value) {
      String _gender = '';

      switch (value) {
        case 1:
          _gender = 'Femenino';
          break;
        case 2:
          _gender = 'Masculino';
          break;
        default: _gender = 'unknow';
      }

      return _gender;  
    }

    String get fullProfilePath {
     return profilePath != null
     ? '$_imageBaseUrl$profilePath' 
     : 'https://us.123rf.com/450wm/kritchanut/kritchanut1308/kritchanut130800013/21528486-male-avatar-profile-picture--vector.jpg?ver=6';
    }
}

class MovieCredits {
    MovieCredits({
        required this.cast,
        required this.crew,
    });

    List<Movie> cast;
    List<Movie> crew;

    factory MovieCredits.fromJson(String str) => MovieCredits.fromMap(json.decode(str));

    factory MovieCredits.fromMap(Map<String, dynamic> json) => MovieCredits(
        cast: List<Movie>.from(json["cast"].map((x) => Movie.fromMap(x))),
        crew: List<Movie>.from(json["crew"].map((x) => Movie.fromMap(x))),
    );
}



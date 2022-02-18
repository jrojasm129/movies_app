import 'dart:convert';

const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

class CharacterModel {
    CharacterModel({
        required this.adult,
        required this.gender,
        required this.id,
        required this.name,
        required this.originalName,
        required this.popularity,
        this.profilePath,
        required this.character,
        required this.job,
    });

    bool adult;
    String gender;
    int id;
    String name;
    String originalName;
    double popularity;
    String? profilePath;
    String character;
    String job;

    factory CharacterModel.fromJson(String str) => CharacterModel.fromMap(json.decode(str));

    factory CharacterModel.fromMap(Map<String, dynamic> json) => CharacterModel(
        adult: json["adult"],
        gender: _parseGender(json["gender"]),
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
        character: json["character"] ?? 'unknow',
        job: json["job"] ?? '',
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
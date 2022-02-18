

import 'package:flutter/cupertino.dart';
import 'package:movies_info/models/character_details_model.dart';

import '../api/movies_api.dart';

class PeopleProvider extends ChangeNotifier{

  PeopleProvider(String personId){
    getActorDetails(personId);
  }

  CharacterDetailsModel? actorDetails;

  Future getActorDetails(String personId) async {

    final json = await MoviesApi.httpGet(path: '/person/$personId', appendToResponse: 'movie_credits');
    final CharacterDetailsModel details = CharacterDetailsModel.fromMap(json);

    actorDetails = details;

    notifyListeners();

  }




}
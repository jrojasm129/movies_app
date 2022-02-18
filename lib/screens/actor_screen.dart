import 'package:flutter/material.dart';
import 'package:movies_info/models/character_details_model.dart';
import 'package:movies_info/models/movie_model.dart';
import 'package:movies_info/providers/people_provider.dart';
import 'package:provider/provider.dart';

import '../constants/constants_colors.dart';
import '../widgets/custom_list_title.dart';
import '../widgets/movie_list_slider.dart';

class ActorScreen extends StatefulWidget {
  final String personId;
  const ActorScreen({ 
    Key? key ,
    required this.personId
  }) : super(key: key);

  @override
  _ActorScreenState createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PeopleProvider(widget.personId),
      lazy: false,
      child: Builder(builder: (context) {
        
        final actor = Provider.of<PeopleProvider>(context).actorDetails;
    
        return Scaffold(
        
        body: actor?.id != null ? CustomScrollView(            
          slivers: [
           
            SliverToBoxAdapter(child: _ActorPicture(actor: actor!),
            ),
                
            const SliverToBoxAdapter( child: SizedBox(height: 15)),
        
            SliverToBoxAdapter(child: _Biography(actor: actor)),
    
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
        
            SliverToBoxAdapter(child: _CatingMovies(movies: actor.movieCredits.cast)),
    
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
        
          ],
        )
        : const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor)),),
      );
        
      },),
    );
  }
}


class _ActorPicture extends StatelessWidget {
  const _ActorPicture({
    Key? key,
    required this.actor,
  }) : super(key: key);


  final  CharacterDetailsModel actor;

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.7,
          child: Stack(
            children: [

              Positioned(
                top: 0,
                child: Container(
                  height: screenSize.height * 0.7,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(actor.fullProfilePath), fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: screenSize.height * 0.71,
                  width: screenSize.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black
                      ],
                      stops: [
                        0.6,
                        1
                      ]
                    )
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20, vertical: 30),
                  child: Text(
                    actor.name, 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 35, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    const Text('Popularidad', style: TextStyle(color: Colors.white),),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: kprimaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        '${actor.popularity}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _Biography extends StatefulWidget {
  const _Biography({
    Key? key,
    required this.actor,
  }) : super(key: key);

    final  CharacterDetailsModel actor;

  @override
  State<_Biography> createState() => _BiographyState();
}

class _BiographyState extends State<_Biography> {

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomListTitle(title: 'Biografía', fontSize: 18, padding: EdgeInsets.zero,),

          const SizedBox(height: 8),
          
          Text(
             widget.actor.biography,
             style: const TextStyle(color: Colors.white, letterSpacing: -0.5),
             textAlign: TextAlign.justify,
             maxLines: expanded ? null : 6,
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              style: TextButton.styleFrom(
                primary: kprimaryColor,
              ),
              onPressed: () {
                setState(() {
                   expanded = !expanded;
                });
              }, 
              child: Text(expanded ? 'Leer menos...' : 'Leer más...', 
              style: const TextStyle(
                color: kprimaryColor,
                fontSize: 12
              ),)
            ),
          )
          
        ],
      ),
    );
  }
}

class _CatingMovies extends StatelessWidget {

  final List<Movie> movies;

  const _CatingMovies({
    Key? key, 
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomListTitle(title: 'Ha participado en', fontSize: 16, padding: EdgeInsets.only(left: 10),),
    
        const SizedBox(height: 10),
    
        MovieListSlider(
          collection: 'actorMovies',
          height: 200,
          itemExtent: 120,
          movies:movies,
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:movies_info/constants/constants_colors.dart';
import 'package:movies_info/models/character_model.dart';
import 'package:movies_info/screens/actor_screen.dart';
import 'package:shimmer/shimmer.dart';

class CharacterSlider extends StatefulWidget {

  final List<CharacterModel> characters;
  final double height;
  final Function? onScrollEnds;
  final String collection;
  final bool replaceRoute;

  const CharacterSlider({
    Key? key,
    required this.characters,
    this.onScrollEnds,
    this.height = 130,
    required this.collection, 
    this.replaceRoute = false
  }) : super(key: key);



  @override
  State<CharacterSlider> createState() => _CharacterSliderState();
}

class _CharacterSliderState extends State<CharacterSlider> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: widget.characters.isNotEmpty 
       ? ListView.builder(
           physics: const BouncingScrollPhysics(),
           scrollDirection: Axis.horizontal,
           itemCount: widget.characters.length,
           itemBuilder: (context, i) {
           
             final character = widget.characters[i];

             return GestureDetector(
               child: _ListItem(
                 radius: (widget.height-45)/2,
                 character: character
               ),
               onTap: (){
                 print(character.id);
                 widget.replaceRoute 
                 ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ActorScreen(personId: character.id.toString())))
                 : Navigator.push(context, MaterialPageRoute(builder: (context) => ActorScreen(personId: character.id.toString())));
               },
             );
           },
        )
       : ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, i) {      
          return Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(.3), 
            highlightColor: Colors.grey.withOpacity(0.6),
            child: const _EmptyListItem(), 
          );
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  
  final CharacterModel character;
  final double radius;
  
  const _ListItem({
    Key? key,
    required this.character, 
    this.radius = 50,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Container(
            height: radius * 2.clamp(1, radius * 2),
            width: radius * 2.clamp(1, radius * 2),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: kprimaryColor.withOpacity(0.3)),
              image: DecorationImage(
                image: NetworkImage(character.fullProfilePath),
                fit: BoxFit.cover,
              )
            )
          ),

          SizedBox(
            width: radius*2,
            child: RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
             text: TextSpan(
               children: [
                 TextSpan(                   
                   text: character.name,
                   style: const TextStyle(
                     color: Colors.white,                     
                     fontSize: 12,
                   ),
                 ),
                 TextSpan(                   
                   text: ' (${character.character})',
                   style: const TextStyle(
                     fontSize: 11,
                     color: kprimaryColor,
                     fontStyle: FontStyle.italic
                   ),
                 ),
               ]
             ),
            ),
          )     
        ],
      ),
    );
  }
}

class _EmptyListItem extends StatelessWidget {
  const _EmptyListItem({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        children: [
          
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
              
                    Container(
                      height: 30,
                      width: 60,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8)
                      ),
                    ),  
              
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle
                      )                      
                    ),
                  ],
                ),
              )
            ),
          ),

          const SizedBox(height: 5),                
      
          Container(
            height: 40,           
            decoration: BoxDecoration(
               color: Colors.grey,
              borderRadius: BorderRadius.circular(20)
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:movies_info/delegates/search_delegate.dart';

import '../constants/constants_colors.dart';
import '../screens/movie_details_screen.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
         final movie = await showSearch(
           context: context, delegate: CustomSearchDelegate()
         ); 
         
         if(movie == null) return;

          movie.heroTag= 'results + $movie.id';

         Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie.id.toString(), heroTag: movie.heroTag!)));

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        alignment: Alignment.center,
        width: 250,
        child: Row(
          children: const [
            Icon(Icons.search_rounded, color: Colors.white38),
            SizedBox(width: 5),
            Text('Busca una película...', style: TextStyle(color: Colors.white38),)
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: kprimaryColor),
          borderRadius: BorderRadius.circular(20) 
        ),
      ),
    );
  }
}

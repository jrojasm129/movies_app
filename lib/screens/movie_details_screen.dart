
import 'package:flutter/material.dart';
import 'package:movies_info/constants/constants_colors.dart';
import 'package:movies_info/models/character_model.dart';
import 'package:movies_info/models/movie_details_model.dart';
import 'package:movies_info/models/video_model.dart';
import 'package:movies_info/providers/movie_details_provider.dart';
import 'package:movies_info/screens/video_player_screen.dart';
import 'package:movies_info/widgets/custom_list_title.dart';
import 'package:provider/provider.dart';

import '../widgets/character_slider.dart';
import '../widgets/movie_list_slider.dart';

class MovieDetailsScreen extends StatefulWidget {

  final String movieId; 
  final String heroTag;

  const MovieDetailsScreen({
     Key? key,
     required this.movieId,
     required this.heroTag
  }) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoviesDetailsProvider(widget.movieId),
      lazy: false,
      child: Builder(builder: (context) {

        final movie = Provider.of<MoviesDetailsProvider>(context).movieDetails;
        
        return Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: const BackButton(color: Colors.white),
              ),
              body: movie?.id != null
                  ? CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _MovieHeader(movie: movie!)),
                       
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                       
                        SliverToBoxAdapter(child: _MovieCategories(movie: movie)),
                       
                        const SliverToBoxAdapter(child: SizedBox(height: 15)),
                       
                        SliverToBoxAdapter(child: _Overview(movie: movie)),
                       
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                       
                        SliverToBoxAdapter(child: _Characters(characters: movie.credits.cast)),
                       
                        const SliverToBoxAdapter(child: SizedBox(height: 15)),
                       
                        SliverToBoxAdapter(child: _MovieVideos(movie: movie)),
                       
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                       
                        SliverToBoxAdapter(child: _SimilarMovies(movie: movie)),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                  )
                  : const Center(
                      child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor))
                    )
        );
      },),
    );
  }
}

class _Characters extends StatelessWidget {

  final List<CharacterModel> characters;

  const _Characters({
    Key? key, 
    required this.characters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomListTitle(title: 'Casting', fontSize: 18, padding: EdgeInsets.only(left: 10)),
    
        const SizedBox(height: 10),
    
        CharacterSlider(
          collection: 'MoviesDetails',
          characters: characters
        ),
      ],
    );
  }
}


class _SimilarMovies extends StatelessWidget {

  final MovieDetailsModel movie;

  const _SimilarMovies({
    Key? key, 
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final movieDetailsProvider= Provider.of<MoviesDetailsProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomListTitle(title: 'Te puede interesar', fontSize: 20, padding: EdgeInsets.only(left: 10),),
    
        const SizedBox(height: 10),
    
        MovieListSlider(
          collection: 'SimilarMovies',
          height: 200,
          itemExtent: 120,
          movies: movieDetailsProvider.similarMovies,
          onScrollEnds: (){
            if(!movieDetailsProvider.isLoadingSimilarMovies){
              movieDetailsProvider.getSimilarMovies(movieId: movie.id.toString());
            }
          },
        ),
      ],
    );
  }
}

class _MovieVideos extends StatelessWidget {  

  final MovieDetailsModel movie;

  const _MovieVideos({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return movie.videos.results.isNotEmpty ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomListTitle(title: 'Trailers y videos', fontSize: 18, padding: EdgeInsets.only(left: 10),),
        const SizedBox(height: 5),
        AspectRatio(
          aspectRatio: 4/3,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: movie.videos.results.length,
            itemBuilder: (context, index) {
              return MovieVideoItem(video: movie.videos.results[index]);
            },
          ),
        ),
      ], 
    )
    : const CustomListTitle(title: 'Trailers y videos no disponibles', fontSize: 18, padding: EdgeInsets.zero,);
  }
}

class MovieVideoItem extends StatelessWidget {
  final VideoModel video;

  const MovieVideoItem({
    Key? key, 
    required this.video
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {



   return GestureDetector(
     onTap: () {
       
       Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(videoId: video.key)
            )
       );
      },
     child: Stack(
       alignment: Alignment.center,
       children: [
         Hero(
           tag: video.key,
           child: Container(
             margin: const EdgeInsets.only(right: 10),
             decoration: BoxDecoration(
               image: DecorationImage(
                 image: NetworkImage(
                        'https://img.youtube.com/vi/${video.key}/0.jpg'
                 ),
                 fit: BoxFit.fill
               )
             ) 
           ),
         ),
      
         Icon(Icons.play_arrow_rounded, color: Colors.white.withOpacity(0.5), size: 60),
         Positioned(
           left: 0,
           top: 8,
           child: Text(
              video.official ? 'Video oficial' : 'Video no oficial',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
         )
       ],
     ),
   );
   }  
 }


class _Overview extends StatelessWidget {
  const _Overview({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieDetailsModel movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomListTitle(title: 'Vista general', fontSize: 18, padding: EdgeInsets.zero,),

          const SizedBox(height: 8),
          
          Text(
             movie.overview!,
             style: const TextStyle(color: Colors.white, letterSpacing: -0.5),
             textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class _MovieCategories extends StatelessWidget {
  const _MovieCategories({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieDetailsModel movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 3,
        runSpacing: 3,
        children: movie.genres.map((e) => Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1)
          ),
          child: Text(e.name, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        )).toList(),
      ),
    );
  }
}

class _MovieHeader extends StatelessWidget {
  const _MovieHeader({
    Key? key,
    required this.movie,
  }) : super(key: key);


  final MovieDetailsModel movie;

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.45,
          child: Stack(
            children: [

              Positioned(
                top: 0,
                child: Container(
                  height: screenSize.height * 0.45,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(movie.fullBackdropPath), fit: BoxFit.fill),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: screenSize.height * 0.45,
                  width: screenSize.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                      Colors.transparent,
                      Colors.black
                    ])
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                right: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.status, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                    ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: screenSize.width * 0.75),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: movie.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: movie.releaseDate != null
                                  ? '  (${movie.releaseDate!.year})'
                                  : '',
                              style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ]))),

                    movie.tagline! != '' 
                    ? ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: screenSize.width * 0.75),
                      child: Text(
                        movie.tagline!, 
                        style: const TextStyle(
                          color: Colors.white70, 
                          fontStyle: FontStyle.italic,
                          // overflow: TextOverflow.ellipsis
                        )
                      ),
                    )
                    : const SizedBox.shrink()
                  ],
                )
              ),

              Positioned(
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    const Text('Rating', style: TextStyle(color: Colors.white),),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: kprimaryColor.withOpacity(0.8),
                          shape: BoxShape.circle),
                      child: Text(
                        '${movie.voteAverage}',
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
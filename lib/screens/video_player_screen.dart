
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../constants/constants_colors.dart';


class VideoPlayerScreen extends StatefulWidget {
  
  const VideoPlayerScreen({ Key? key, required this.videoId }) : super(key: key);

  final String videoId;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  late YoutubePlayerController _ytController; 

  @override
  void initState() {
    _ytController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      params: const YoutubePlayerParams(
        autoPlay: true,
        showFullscreenButton: true
      )
    );
    super.initState();
  }

  @override
  void dispose() {
    _ytController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(aspectRatio: 4/3,);
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _ytController,
      child: Scaffold(
          body: Center(
            child: Stack(
        children: [
            player,
            Positioned.fill(
              child: YoutubeValueBuilder(
                controller: _ytController,
                builder: (context, value) {
                
                 if (value.isReady) _ytController.play();

                  return AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Material(
                      child: Hero(
                        tag: widget.videoId,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://img.youtube.com/vi/${widget.videoId}/0.jpg'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator.adaptive(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(kprimaryColor)),
                          ),
                        ),
                      ),
                    ),
                    crossFadeState: value.isReady
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  );
                },
              ),
            ),
        ],
      ),
          )),
    );
  }
}
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallette.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/widgets/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    if (currentSong == null) {
      return SizedBox();
    }
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const MusicPlayer();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeIn));
                final offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
            //   MaterialPageRoute(builder: (context){
            //     return const MusicPlayer();
            // },
            // )
          );
        },
        child: Stack(
          children: [
            Container(
              height: 66,
              width: MediaQuery.of(context).size.width - 16,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        hexToColor(currentSong!.hexcode),
                        const Color(0xff121212)
                      ]),
                  // color: hexToColor(currentSong.hexcode),
                  borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                          tag: 'music-image',
                          child: Container(
                            width: 48,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      NetworkImage(currentSong.thumbnail_url),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentSong.song_name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            currentSong.artist_name.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Pallete.whiteColor),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.heart,
                            color: Pallete.whiteColor,
                          )),
                      IconButton(
                          onPressed: songNotifier.playPause,
                          icon: Icon(
                            songNotifier.isPlaying
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_fill,
                            color: Pallete.whiteColor,
                          ))
                    ],
                  )
                ],
              ),
            ),
            StreamBuilder(
                stream: songNotifier.audioPlayer!.positionStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  final position = snapshot.data;
                  final duration = songNotifier.audioPlayer!.duration;
                  double sliderValue = 0.0;
                  if (position != null && duration != null) {
                    sliderValue =
                        position.inMilliseconds / duration.inMilliseconds;
                  }
                  return Positioned(
                      bottom: 0,
                      left: 8,
                      child: Container(
                        height: 2,
                        width: sliderValue *
                            (MediaQuery.of(context).size.width - 32),
                        decoration: BoxDecoration(
                            color: Pallete.whiteColor,
                            borderRadius: BorderRadius.circular(7)),
                      ));
                }),
            Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width - 32,
                  decoration: BoxDecoration(
                      color: Pallete.inactiveSeekColor,
                      borderRadius: BorderRadius.circular(7)),
                ))
          ],
        ));
  }
}

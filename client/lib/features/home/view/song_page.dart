import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallette.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongPage extends ConsumerWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Latest Today',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ref.watch(getAllSongsProvider).when(data: (songs) {
          return SizedBox(
              height: 260,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    print(song);
                    return GestureDetector(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(song.thumbnail_url),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(7.0)),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.song_name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist_name,
                                    style: const TextStyle(
                                        color: Pallete.subtitleText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            )));
                  }));
        }, error: (error, st) {
          return Center(child: Text(error.toString()));
        }, loading: () {
          return const Loader();
        })
      ],
    ));
  }
}

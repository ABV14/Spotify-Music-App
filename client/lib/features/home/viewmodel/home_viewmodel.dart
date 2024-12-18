import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async{
    final token = ref.watch(currentUserNotifierProvider)!.token;
    final res = await ref.watch(homeRepositoryProvider).getAllSongs(token:token);

    return switch(res){
      Left(value:final l) => throw l.message, 
      // ignore: dead_code
      Right(value:final r) => r, 
    };

}


@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build(){
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }
  Future<void> uploadSong({required File selectedAudio, required File selectedThumbnail, required String songName, required String artist, required Color selectedColor}) async{
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final value = switch (res){
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value:final r) => state = AsyncValue.data(r)
    };

    print(value);
  } 
}
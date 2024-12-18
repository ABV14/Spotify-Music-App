import 'dart:convert';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref){
  return HomeRepository();
}
class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({required File selectedAudio, required File selectedThumbnail, required String songName, required String artist, required String hexCode, required String token}) async {
    try{
    final request = http.MultipartRequest(
        'POST', Uri.parse('${ServerConstant.serverURL}/song/upload'));
    request
      ..files.addAll([
        await http.MultipartFile.fromPath("song", selectedAudio.path),
        await http.MultipartFile.fromPath(
            "thumbnail", selectedThumbnail.path),
      ])
      ..fields.addAll({
        "artist": artist,
        "song_name": songName,
        "hex_code": hexCode,
        "color":'red'
      })
      ..headers.addAll({
        'x-auth-token': token
      });
    final res = await request.send();
    if(res.statusCode!=201){
      Left(AppFailure(await res.stream.bytesToString()));
    }
    return Right(await res.stream.bytesToString());
    }
    catch(e){
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure,List<SongModel>>> getAllSongs({
    required String token 
  }) async{
      try{
        final res = await http.get(Uri.parse("${ServerConstant.serverURL}/song/songs"),
        headers: {
          "Content-Type":"application/json",
          "x-auth-token":token
        });
        var responseBodyAsMap = jsonDecode(res.body);

        if(res.statusCode !=200){
          responseBodyAsMap = responseBodyAsMap as Map<String, dynamic>;
          return Left(AppFailure(responseBodyAsMap['detail']));
        }
        responseBodyAsMap = responseBodyAsMap as List;
        List<SongModel> songs = [];
        for(final map in responseBodyAsMap){
              songs.add(SongModel.fromMap(map));
          }
        return Right(songs);
      }
      catch(e){
        return Left(AppFailure(e.toString()));
      }
  }
}

import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SongModel {
  final String id;
  final String song_name;
  final String artist_name;
  final String thumbnail_url;
  final String songUrl;
  final String hexcode;
  SongModel({
    required this.id,
    required this.song_name,
    required this.artist_name,
    required this.thumbnail_url,
    required this.songUrl,
    required this.hexcode,
  });

  SongModel copyWith({
    String? id,
    String? song_name,
    String? artist_name,
    String? thumbnail_url,
    String? songUrl,
    String? hexcode,
  }) {
    return SongModel(
      id: id ?? this.id,
      song_name: song_name ?? this.song_name,
      artist_name: artist_name ?? this.artist_name,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      songUrl: songUrl ?? this.songUrl,
      hexcode: hexcode ?? this.hexcode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': song_name,
      'artist_name': artist_name,
      'thumbnail_url': thumbnail_url,
      'songUrl': songUrl,
      'hexcode': hexcode,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? "",
      song_name: map['song_name'] ?? "",
      artist_name: map['artist_name'] ?? "",
      thumbnail_url: map['thumbnail_url'] ?? "",
      songUrl: map['songUrl'] ?? "",
      hexcode: map['hexcode'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) => SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, song_name: $song_name, artist_name: $artist_name, thumbnail_url: $thumbnail_url, songUrl: $songUrl, hexcode: $hexcode)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.song_name == song_name &&
      other.artist_name == artist_name &&
      other.thumbnail_url == thumbnail_url &&
      other.songUrl == songUrl &&
      other.hexcode == hexcode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      song_name.hashCode ^
      artist_name.hashCode ^
      thumbnail_url.hashCode ^
      songUrl.hashCode ^
      hexcode.hashCode;
  }
}


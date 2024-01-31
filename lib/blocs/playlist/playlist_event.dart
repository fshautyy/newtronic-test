part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistEvent {}

final class FecthPlaylist extends PlaylistEvent {}

final class FecthPlaylistUrl extends PlaylistEvent {
  final String url;
  final String id;

  FecthPlaylistUrl({required this.url, required this.id});
}

part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistState {}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistLoading extends PlaylistState {}

final class PlaylistLoaded extends PlaylistState {
  final List<Playlist> listItem;
  final String thumbnail;

  PlaylistLoaded({required this.listItem, required this.thumbnail});

  List<Object> get props => [listItem, thumbnail];
}

final class PlaylistError extends PlaylistState {
  final String errorMessage;

  PlaylistError({required this.errorMessage});

  List<Object> get props => [errorMessage];
}

final class PlaylistUrlLoaded extends PlaylistState {
  final List<ProgressiveFile> list;
  final String id;

  PlaylistUrlLoaded({required this.list, required this.id});
  List<Object> get props => [list, id];
}

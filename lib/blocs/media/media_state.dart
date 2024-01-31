part of 'media_bloc.dart';

@immutable
abstract class MediaState {}

final class MediaInitial extends MediaState {}

final class MediaBanner extends MediaState {
  final ApiData item;

  MediaBanner({required this.item});

  List<Object> get props => [item];
}

final class MediaLoading extends MediaState {}

final class MediaError extends MediaState {
  final String errorMessage;

  MediaError({required this.errorMessage});

  List<Object> get props => [errorMessage];
}

final class PlayMediaState extends MediaState {
  final String url;
  final String title;
  final String desc;
  final String type;
  final String thumbnail;

  PlayMediaState(
      {required this.url,
      required this.title,
      required this.desc,
      required this.type,
      required this.thumbnail});

  List<Object> get props => [url, title, desc, type, thumbnail];
}

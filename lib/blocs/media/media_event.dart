part of 'media_bloc.dart';

@immutable
abstract class MediaEvent {}

final class PlayMedia extends MediaEvent {
  final String url;
  final String title;
  final String desc;
  final String type;
  final String thumbnail;

  PlayMedia(
      {required this.url,
      required this.title,
      required this.desc,
      required this.type,
      required this.thumbnail});
}

final class GetBanner extends MediaEvent {}

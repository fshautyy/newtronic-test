import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtronic/configs/list.dart';
import 'package:path_provider/path_provider.dart';

abstract class VideoEvent {}

class ChangeVideoEvent extends VideoEvent {
  final String videoUrl;

  ChangeVideoEvent(this.videoUrl);
}

class VideoState {
  final String url;
  final String id;
  VideoState(this.url, this.id);
}

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState('', '')) {
    on<ChangeVideoEvent>((event, emit) async {
      var tempDir = await getDownloadsDirectory();
      String idv = getVimeoVideoId(event.videoUrl);
      String fullPath = "${tempDir!.path}/$idv.mp4";
      emit(VideoState(fullPath, idv));
    });
  }
}

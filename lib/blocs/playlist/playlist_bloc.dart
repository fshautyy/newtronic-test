// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newtronic/configs/list.dart';
import 'package:newtronic/models/model.dart';
import 'package:newtronic/models/video.dart';
import 'package:newtronic/repositories/item.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final NewtronicItemRepo repo = NewtronicItemRepo();

  PlaylistBloc() : super(PlaylistInitial()) {
    on<PlaylistEvent>((event, emit) {});

    on<FecthPlaylist>((event, emit) async {
      emit(PlaylistLoading());
      await Future.delayed(const Duration(seconds: 1));
      try {
        final post = await repo.fetchItem();
        final thumbnail = await repo.getThumbnail();
        emit(PlaylistLoaded(listItem: post, thumbnail: thumbnail));
      } catch (e) {
        emit(PlaylistError(errorMessage: e.toString()));
      }
    });

    on<FecthPlaylistUrl>((event, emit) async {
      try {
        final post = await repo.getDownloadLink(vId: event.url);
        emit(PlaylistUrlLoaded(list: post, id: getVimeoVideoId(event.id)));
      } catch (e) {
        emit(PlaylistError(errorMessage: e.toString()));
      }
    });
  }
}

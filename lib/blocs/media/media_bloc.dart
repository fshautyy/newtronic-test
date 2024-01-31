// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newtronic/models/model.dart';
import 'package:newtronic/repositories/item.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final NewtronicItemRepo repo = NewtronicItemRepo();

  MediaBloc() : super(MediaInitial()) {
    on<MediaEvent>((event, emit) {});
    on<GetBanner>((event, emit) async {
      emit(MediaLoading());
      try {
        final item = await repo.getbanner();
        emit(MediaBanner(item: item));
      } catch (e) {
        emit(MediaError(errorMessage: e.toString()));
      }
    });
    on<PlayMedia>((event, emit) async {
      emit(MediaLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(PlayMediaState(
          url: event.url,
          title: event.title,
          desc: event.desc,
          type: event.type,
          thumbnail: event.thumbnail));
    });
  }
}

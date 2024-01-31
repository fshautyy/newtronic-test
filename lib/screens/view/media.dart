import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:newtronic/blocs/media/media_bloc.dart';
import 'package:newtronic/blocs/video/video.dart';
import 'package:newtronic/configs/color.dart';
import 'package:newtronic/configs/list.dart';
import 'package:newtronic/configs/player.dart';

class MediaPlayer extends StatelessWidget {
  const MediaPlayer({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: size.height * 0.45,
      child: BlocConsumer<MediaBloc, MediaState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PlayMediaState) {
            final thumbs = state.thumbnail;
            final uri = state.url;
            return Column(
              children: [
                if (state.type == 'image')
                  Image.network(
                    state.url,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: size.height * 0.28,
                  ),
                if (state.type == 'video')
                  BlocProvider(
                    create: (context) => VideoBloc(),
                    child: BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        if (state.url != '') {
                          return SizedBox(
                            width: double.infinity,
                            height: size.height * 0.28,
                            child: VidPlayer(
                              videoId: getVimeoVideoId(uri),
                            ),
                          );
                        } else {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                thumbs,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: size.height * 0.28,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.5),
                                width: double.infinity,
                                height: size.height * 0.28,
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<VideoBloc>(context)
                                      .add(ChangeVideoEvent(uri));
                                },
                                child: const Icon(
                                  Icons.play_circle_fill,
                                  size: 60,
                                  color: ColorSelect.primaryColor,
                                ),
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                if (state.type == 'downloaded')
                  BlocProvider(
                    create: (context) => VideoBloc(),
                    child: BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        if (state.url != '') {
                          return SizedBox(
                              width: double.infinity,
                              height: size.height * 0.28,
                              child: NativeVideoView(
                                keepAspectRatio: true,
                                showMediaController: true,
                                enableVolumeControl: true,
                                onCreated: (controller) {
                                  controller.setVideoSource(
                                    state.url,
                                    sourceType: VideoSourceType.file,
                                    requestAudioFocus: true,
                                  );
                                },
                                onPrepared: (controller, info) {
                                  controller.play();
                                },
                                onError: (controller, what, extra, message) {
                                  debugPrint(
                                      'NativeVideoView: Player Error ($what | $extra | $message)');
                                },
                                onCompletion: (controller) {
                                  debugPrint(
                                      'NativeVideoView: Video completed');
                                },
                              ));
                        } else {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                thumbs,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: size.height * 0.28,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.5),
                                width: double.infinity,
                                height: size.height * 0.28,
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<VideoBloc>(context)
                                      .add(ChangeVideoEvent(uri));
                                },
                                child: const Icon(
                                  Icons.play_circle_fill,
                                  size: 60,
                                  color: ColorSelect.primaryColor,
                                ),
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                const SizedBox(
                  height: 8,
                ),
                ListTile(
                  title: Text(
                    state.title,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, height: 1),
                  ),
                  subtitle: Text(
                    state.desc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 1),
                  ),
                ),
              ],
            );
          } else if (state is MediaLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MediaBanner) {
            final sst = state.item.data![0];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Image.network(
                    sst.logo!,
                    width: double.infinity,
                    height: size.height * 0.28,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ListTile(
                  title: Text(
                    sst.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    sst.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 1),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtronic/blocs/media/media_bloc.dart';
import 'package:newtronic/blocs/playlist/playlist_bloc.dart';
import 'package:newtronic/configs/list.dart';
import 'package:newtronic/repositories/item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Playlist extends StatelessWidget {
  const Playlist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BlocConsumer<PlaylistBloc, PlaylistState>(
      listener: (context, state) {
        if (state is PlaylistError) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.errorMessage),
                );
              });
        }
      },
      builder: (context, state) {
        if (state is PlaylistInitial) {
          return Container(
            color: Colors.black,
          );
        } else if (state is PlaylistLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PlaylistLoaded) {
          final list = state.listItem;
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final play = list[i];
                return FutureBuilder<bool>(
                  future: () async {
                    final tempDir = await getDownloadsDirectory();
                    final fullPath =
                        '${tempDir!.path}/${getVimeoVideoId(play.url!)}.mp4';
                    final file = File(fullPath);
                    return await file.exists();
                  }(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bool downloaded = snapshot.data!;
                      return InkWell(
                        onTap: () {
                          BlocProvider.of<MediaBloc>(context).add(PlayMedia(
                              url: play.url!,
                              title: play.title!,
                              type: downloaded ? 'downloaded' : play.type!,
                              desc: play.description!,
                              thumbnail: state.thumbnail));
                        },
                        child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black)),
                            height: MediaQuery.of(context).size.height * 0.09,
                            child: Row(
                              children: [
                                Icon(
                                  play.type == 'video'
                                      ? Icons.play_circle_fill
                                      : Icons.image,
                                  size: 45,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.53,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        play.title!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            height: 1),
                                      ),
                                      Text(
                                        play.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            height: 1, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (play.type == "video")
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        var status =
                                            await Permission.storage.status;
                                        if (status.isGranted) {
                                          var tempDir =
                                              await getDownloadsDirectory();
                                          String fullPath =
                                              "${tempDir!.path}/${getVimeoVideoId(play.url!)}.mp4";
                                          File file = File(fullPath);
                                          if (!downloaded) {
                                            BlocProvider.of<PlaylistBloc>(
                                                    context)
                                                .add(FecthPlaylistUrl(
                                                    url: play.url!,
                                                    id: play.url!));
                                          } else {
                                            await file
                                                .delete()
                                                .then((value) => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const AlertDialog(
                                                        title: Text(
                                                            'Media Dihapus!'),
                                                        backgroundColor:
                                                            Colors.white,
                                                        icon: Icon(
                                                          Icons
                                                              .check_circle_outline_outlined,
                                                          color: Colors.blue,
                                                        ),
                                                      );
                                                    }));
                                            BlocProvider.of<PlaylistBloc>(
                                                    context)
                                                .add(FecthPlaylist());
                                          }
                                        } else {
                                          await Permission.storage.request();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: downloaded
                                            ? const Color(0XFF69f537)
                                            : const Color(0XFF0073f0),
                                        foregroundColor: Colors.white,
                                        shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        minimumSize: const Size(40, 10),
                                      ),
                                      child: Text(
                                        downloaded ? "Tersimpan" : 'Simpan',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  )
                              ],
                            )),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              });
        } else if (state is PlaylistUrlLoaded) {
          state.list.sort((a, b) => a.height!.compareTo(b.height!));
          return Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Download Media',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: state.list.length,
                      itemBuilder: (context, i) {
                        final item = state.list[i];
                        return ListTile(
                          onTap: () async {
                            const SnackBar snackBar =
                                SnackBar(content: Text("Download Started"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            final NewtronicItemRepo repo = NewtronicItemRepo();

                            await repo.download2(item.url!, state.id).then(
                                (value) => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            title: Text('Sukses'),
                                            backgroundColor: Colors.white,
                                            icon: Icon(
                                              Icons
                                                  .check_circle_outline_outlined,
                                              color: Colors.blue,
                                            ),
                                          );
                                        })
                                    .then((value) =>
                                        BlocProvider.of<PlaylistBloc>(context)
                                            .add(FecthPlaylist())));
                          },
                          title: Text(item.quality!),
                          subtitle: Text(item.mime!),
                          leading: const Icon(Icons.download),
                        );
                      }))
            ],
          );
        } else {
          return Container();
        }
      },
    ));
  }
}

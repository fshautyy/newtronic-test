// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:newtronic/blocs/media/media_bloc.dart';
import 'package:newtronic/blocs/playlist/playlist_bloc.dart';
import 'package:newtronic/blocs/video/tab.dart';
import 'package:newtronic/configs/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtronic/screens/view/media.dart';
import 'package:newtronic/screens/view/playlist.dart';
import 'package:newtronic/screens/view/tab.dart';

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorSelect.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            width: 140,
          ),
        ),
        backgroundColor: ColorSelect.primaryColor,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PlaylistBloc()..add(FecthPlaylist()),
          ),
          BlocProvider(
            create: (context) => MediaBloc()..add(GetBanner()),
          ),
          BlocProvider(
            create: (context) => TabBloc(),
          ),
        ],
        child: Column(
          children: [
            MediaPlayer(size: size),
            TabMenu(size: size),
            const SizedBox(
              height: 5,
            ),
            const Playlist()
          ],
        ),
      ),
    );
  }
}

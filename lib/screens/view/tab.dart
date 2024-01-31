import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtronic/blocs/playlist/playlist_bloc.dart';
import 'package:newtronic/blocs/video/tab.dart';
import 'package:newtronic/configs/list.dart';

class TabMenu extends StatelessWidget {
  const TabMenu({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TabBloc, TabState>(
      listener: (context, state) {},
      builder: (context, state) {
        int index = state.index;
        return SizedBox(
          height: size.height * 0.06,
          child: ListView.builder(
              itemCount: submenu.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              index == i ? Colors.blue : Colors.grey[300],
                          foregroundColor:
                              index == i ? Colors.white : Colors.black,
                          minimumSize: const Size(50, 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        BlocProvider.of<PlaylistBloc>(context)
                            .add(FecthPlaylist());
                        BlocProvider.of<TabBloc>(context)
                            .add(ChangeTabEvent(i));
                      },
                      child: Text(
                        submenu[i],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                );
              }),
        );
      },
    );
  }
}

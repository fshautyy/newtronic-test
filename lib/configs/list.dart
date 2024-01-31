import 'dart:io';

import 'package:path_provider/path_provider.dart';

List<String> submenu = ['Produk', 'Materi', 'Layanan', 'Artikel'];

String getVimeoVideoId(String vimeoUrl) {
  RegExp regex = RegExp(r'/video/(\d+)');
  var match = regex.firstMatch(vimeoUrl);
  String videoId = match?.group(1) ?? "";
  return videoId;
}

Future<bool> isDownloaded(String item) async {
  var tempDir = await getDownloadsDirectory();
  String fullPath = "${tempDir!.path}/$item.mp4";

  File file = File(fullPath);
  bool fileExists = await file.exists();

  if (fileExists) {
    return true;
  } else {
    return false;
  }
}

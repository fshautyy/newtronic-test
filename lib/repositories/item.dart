// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:newtronic/configs/api.dart';
import 'package:newtronic/configs/list.dart';
import 'package:newtronic/models/model.dart';
import 'package:newtronic/models/video.dart';
import 'package:path_provider/path_provider.dart';

class NewtronicItemRepo {
  Future download2(String url, String item) async {
    var dio = Dio();
    var tempDir = await getDownloadsDirectory();
    String fullPath = "${tempDir!.path}/$item.mp4";
    try {
      Response response = await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Playlist>> fetchItem() async {
    List<Playlist> list = [];
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        var item = ApiData.fromJson(map);
        if (map['status'] == 200) {
          var data = item.data;
          if (data![0].playlist!.isNotEmpty) {
            list = data[0].playlist!;
            return list;
          } else {
            return [];
          }
        } else {
          return list;
        }
      } else {
        throw 'Gagal mendapati data Playlist, silahkan Periksa koneksi internet anda';
      }
    } catch (e) {
      print(e);
      throw 'Gagal mendapati data Playlist, silahkan Periksa koneksi internet anda';
    }
  }

  Future<ApiData> getbanner() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        var item = ApiData.fromJson(map);
        if (map['status'] == 200) {
          if (item.status == 200) {
            return item;
          } else {
            throw 'Gagal mendapati data Banner, silahkan Periksa koneksi internet anda';
          }
        } else {
          throw 'Gagal mendapati data Banner, silahkan Periksa koneksi internet anda';
        }
      } else {
        throw 'Gagal mendapati data Banner, silahkan Periksa koneksi internet anda';
      }
    } catch (e) {
      print(e);
      throw 'Gagal mendapati data Banner, Kesalahan tidak terdefinisi';
    }
  }

  Future<String> getThumbnail() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        var item = ApiData.fromJson(map);
        if (map['status'] == 200) {
          var data = item.data;
          return data![0].banner!;
        } else {
          return 'No Image';
        }
      } else {
        return 'No Image';
      }
    } catch (e) {
      print(e);
      throw 'Gagal mendapati data Thumbnail, Kesalahan tidak terdefinisi';
    }
  }

  Future<List<ProgressiveFile>> getDownloadLink({required String vId}) async {
    String videoId = getVimeoVideoId(vId);
    String url = 'https://player.vimeo.com/video/$videoId/config';
    List<ProgressiveFile> listFile = [];
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        final item = map['request']['files']['progressive'];
        for (var e in item) {
          listFile.add(ProgressiveFile.fromJson(e));
        }
        if (listFile.isNotEmpty) {
          return listFile;
        } else {
          return [];
        }
      } else {
        throw 'Tidak dapat terhubung ke server, silahkan periksa kembali jaringan';
      }
    } catch (e) {
      print(e);
      throw 'Gagal mendapati data URL, periksa dns atau gunakan jaringan lain';
    }
  }
}

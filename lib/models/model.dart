class ApiData {
  List<Data>? data;
  int? status;

  ApiData({this.data, this.status});

  ApiData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? description;
  String? banner;
  String? logo;
  String? createdAt;
  String? updatedAt;
  List<Playlist>? playlist;

  Data(
      {this.id,
      this.title,
      this.description,
      this.banner,
      this.logo,
      this.createdAt,
      this.updatedAt,
      this.playlist});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    banner = json['banner'];
    logo = json['logo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['playlist'] != null) {
      playlist = <Playlist>[];
      json['playlist'].forEach((v) {
        playlist!.add(Playlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['banner'] = banner;
    data['logo'] = logo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (playlist != null) {
      data['playlist'] = playlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Playlist {
  int? id;
  int? dirId;
  String? title;
  String? description;
  String? url;
  String? type;
  String? createdAt;
  String? updatedAt;

  Playlist(
      {this.id,
      this.dirId,
      this.title,
      this.description,
      this.url,
      this.type,
      this.createdAt,
      this.updatedAt});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dirId = json['dir_id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dir_id'] = dirId;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

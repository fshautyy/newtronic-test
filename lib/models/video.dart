class ProgressiveFile {
  String? profile;
  int? width;
  int? height;
  String? mime;
  int? fps;
  String? url;
  String? cdn;
  String? quality;
  String? id;
  String? origin;

  ProgressiveFile(
      {this.profile,
      this.width,
      this.height,
      this.mime,
      this.fps,
      this.url,
      this.cdn,
      this.quality,
      this.id,
      this.origin});

  ProgressiveFile.fromJson(Map<String, dynamic> json) {
    profile = json['profile'];
    width = json['width'];
    height = json['height'];
    mime = json['mime'];
    fps = json['fps'];
    url = json['url'];
    cdn = json['cdn'];
    quality = json['quality'];
    id = json['id'];
    origin = json['origin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile'] = profile;
    data['width'] = width;
    data['height'] = height;
    data['mime'] = mime;
    data['fps'] = fps;
    data['url'] = url;
    data['cdn'] = cdn;
    data['quality'] = quality;
    data['id'] = id;
    data['origin'] = origin;
    return data;
  }
}

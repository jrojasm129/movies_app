import 'dart:convert';

class VideoModel {
    VideoModel({
        required this.name,
        required this.key,
        required this.site,
        required this.size,
        required this.type,
        required this.official,
        required this.publishedAt,
        required this.id,
    });

    String name;
    String key;
    String site;
    int size;
    String type;
    bool official;
    DateTime publishedAt;
    String id;

    factory VideoModel.fromJson(String str) => VideoModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory VideoModel.fromMap(Map<String, dynamic> json) => VideoModel(
        name: json["name"],
        key: json["key"],
        site: json["site"],
        size: json["size"],
        type: json["type"],
        official: json["official"],
        publishedAt: DateTime.parse(json["published_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "key": key,
        "site": site,
        "size": size,
        "type": type,
        "official": official,
        "published_at": publishedAt.toIso8601String(),
        "id": id,
    };

     String get fullSitePath {
       String fullPath;

      switch (site) {
        case 'YouTube':
         fullPath = 'https://www.youtu.be/$key';
        break;
        case 'Vimeo':
          fullPath = 'https://vimeo.com/$key';
        break;        
        default: fullPath  = '';
      }

      return fullPath;

      
    }
    
}
class Cast {
  List<Actor> actores = new List();

  Cast.fromJSONlist(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final actor = new Actor.fromJson(item);
      actores.add(actor);
    }
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJson(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_ id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }

  getProfileImg() {
    if (profilePath == null) {
      return 'assets/images/no-image.jpg';
      // return 'https://graduateinstitute.ch/sites/default/files/styles/medium/public/2019-02/no%20Avatar.png?itok=rRB2C1NE';
    }
    return 'https://image.tmdb.org/t/p/w500/$profilePath';
  }
}

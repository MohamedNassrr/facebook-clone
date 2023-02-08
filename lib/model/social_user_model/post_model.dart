class PostsModel{
  String? name;
  String? uId;
  String? images;
  String? dateTime;
  String? text;
  String? postImages;

  PostsModel({
    this.name,
    this.uId,
    this.dateTime,
    this.images,
    this.text,
    this.postImages,
  });
  PostsModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    uId = json['uId'];
    images = json['images'];
    dateTime = json['dateTimes'];
    text = json['texts'];
    postImages = json['postImages'];
  }
  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'uId' : uId,
      'images' : images,
      'postImages' : postImages,
      'dateTimes' : dateTime,
      'texts' : text,
    };
  }
}

class SocialUserModel{
  String? name;
  String? uId;
  String? phone;
  String? email;
  String? bio;
  String? images;
  String? covers;

  SocialUserModel({
    this.name,
    this.uId,
    this.phone,
    this.email,
    this.bio,
    this.images,
    this.covers,
});
  SocialUserModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    uId = json['uId'];
    phone = json['phone'];
    email = json['email'];
    bio = json['bios'];
    images = json['images'];
    covers = json['cavers'];
  }
  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'uId' : uId,
      'phone' : phone,
      'email' : email,
      'bios' : bio,
      'images' : images,
      'cavers' : covers,
    };
  }
}

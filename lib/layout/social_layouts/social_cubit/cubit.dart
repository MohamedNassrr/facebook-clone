import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facetook/layout/social_layouts/social_cubit/state.dart';
import 'package:facetook/model/social_user_model/message_model.dart';
import 'package:facetook/model/social_user_model/post_model.dart';
import 'package:facetook/model/social_user_model/social_user_model.dart';
import 'package:facetook/modules/chats/chat_screen.dart';
import 'package:facetook/modules/feeds/feed_screen.dart';
import 'package:facetook/modules/new_posts/post_screen.dart';
import 'package:facetook/modules/settings/setting_screen.dart';
import 'package:facetook/modules/users/user_screen.dart';
import 'package:facetook/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('User').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      print(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    NewPostsScreen(),
    SettingScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'posts',
    'Settings',
  ];

  void changeNavBottom(int index) {
    if(index == 1)
      getUsers();
    if (index == 2)
      emit(SocialNewPostsState());
    else {
      currentIndex = index;
      emit(SocialChangeNavBarState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final PickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (PickedFile != null) {
      profileImage = File(PickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      debugPrint('no image selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      debugPrint('no cover selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String bio,
    required String phone,
}) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('User/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        updateUser(
            name: name,
            bio: bio,
            phone: phone,
            images: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('User/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        updateUser(
          name: name,
          bio: bio,
          phone: phone,
          covers: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }


  void updateUser({
    required String name,
    required String bio,
    required String phone,
    String? images,
    String? covers,
  }){
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      uId: userModel!.uId,
      email: userModel!.email,
      images: images??userModel!.images,
      covers: covers??userModel!.covers,
    );
    FirebaseFirestore.instance
        .collection('User')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }


  File? postImages;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImages = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      debugPrint('no postImage selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage(){
    postImages = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostsImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreateNewPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Post/${Uri.file(postImages!.path).pathSegments.last}')
        .putFile(postImages!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        createPost(
            dateTime: dateTime,
            text: text,
            postImages: value,
        );
      }).catchError((error) {
        emit(SocialCreateNewPostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreateNewPostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImages,
  }){
    emit(SocialCreateNewPostLoadingState());

    PostsModel model = PostsModel(
      name: userModel!.name,
      uId: userModel!.uId,
      images: userModel!.images,
      dateTime: dateTime,
      postImages: postImages??'',
      text: text,
    );
    FirebaseFirestore.instance
        .collection('Post')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreateNewPostSuccessState());
    }).catchError((error) {
      emit(SocialCreateNewPostErrorState());
    });
  }
  
  List<PostsModel> posts = [];
  List<String> postId = [];
  List<int> like = [];

  void getPost(){
    FirebaseFirestore.instance
        .collection('Post')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            element.reference
            .collection('like')
            .get()
            .then((value) {
              like.add(value.docs.length);
              postId.add(element.id);
              posts.add(PostsModel.fromJson(element.data()));
            })
            .catchError((error){});
          });
          emit(SocialGetPostsSuccessState());
    })
        .catchError((error){
      emit(SocialGetPostsErrorState(error.toString()));

    });
  }

  void likePost(String postsId){
    FirebaseFirestore.instance
        .collection('Post')
        .doc(postsId)
        .collection('like')
        .doc(userModel!.uId)
        .set({
      'like': true,
    })
        .then((value) {
          emit(SocialLikePostsSuccessState());
    })
        .catchError((error){
          emit(SocialLikePostsErrorState(error.toString()));
    });
  }

  List<SocialUserModel> user = [];

  void getUsers() {
    if(user.isEmpty) {
      FirebaseFirestore.instance.collection('User').get().then((value) {
      value.docs.forEach((element) {
        if(element.data()['uId'] != userModel!.uId) {
          user.add(SocialUserModel.fromJson(element.data()));
        }
      });
      emit(SocialGetAllUserSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUserErrorState(error.toString()));
    });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
}){
    MessageModel model = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    // set my chat
    FirebaseFirestore.instance
        .collection('User')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((error) {
      emit(SocialSendMessagesErrorState());
    });
    // set receiver chat
    FirebaseFirestore.instance
        .collection('User')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((error) {
      emit(SocialSendMessagesErrorState());
    });
  }

  List<MessageModel> messages = [];
  
  void getMessages({
    required String receiverId,

  }){
    FirebaseFirestore.instance
        .collection('User')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
          event.docs.forEach((element) {
            messages.add(MessageModel.fromJson(element.data()));
          });
          emit(SocialGetMessagesSuccessState());
    });
  }
}

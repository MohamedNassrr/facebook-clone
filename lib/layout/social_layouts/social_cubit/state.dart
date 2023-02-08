abstract class SocialState{}

class SocialInitialState extends SocialState{}

class SocialGetUserLoadingState extends SocialState{}

class SocialGetUserSuccessState extends SocialState{}

class SocialGetUserErrorState extends SocialState{
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialGetAllUserLoadingState extends SocialState{}

class SocialGetAllUserSuccessState extends SocialState{}

class SocialGetAllUserErrorState extends SocialState{
  final String error;

  SocialGetAllUserErrorState(this.error);
}

class SocialGetPostsLoadingState extends SocialState{}

class SocialGetPostsSuccessState extends SocialState{}

class SocialGetPostsErrorState extends SocialState{
  final String error;

  SocialGetPostsErrorState(this.error);
}

class SocialLikePostsSuccessState extends SocialState{}

class SocialLikePostsErrorState extends SocialState{
  final String error;

  SocialLikePostsErrorState(this.error);
}

class SocialCommentPostsSuccessState extends SocialState{}

class SocialCommentPostsErrorState extends SocialState{
  final String error;

  SocialCommentPostsErrorState(this.error);
}

class SocialChangeNavBarState extends SocialState{}

class SocialNewPostsState extends SocialState{}

class SocialProfileImagePickedSuccessState extends SocialState{}

class SocialProfileImagePickedErrorState extends SocialState{}

class SocialCoverImagePickedSuccessState extends SocialState{}

class SocialCoverImagePickedErrorState extends SocialState{}

class SocialUploadProfileImageSuccessState extends SocialState{}

class SocialUploadProfileImageErrorState extends SocialState{}

class SocialUploadCoverImageSuccessState extends SocialState{}

class SocialUploadCoverImageErrorState extends SocialState{}

class SocialUpdateUserErrorState extends SocialState{}

class SocialUpdateUserLoadingState extends SocialState{}

// create posts states

class SocialCreateNewPostErrorState extends SocialState{}

class SocialCreateNewPostLoadingState extends SocialState{}

class SocialCreateNewPostSuccessState extends SocialState{}

class SocialPostImagePickedSuccessState extends SocialState{}

class SocialPostImagePickedErrorState extends SocialState{}

class SocialRemovePostImageState extends SocialState{}

// chat

class SocialSendMessagesErrorState extends SocialState{}

class SocialSendMessagesSuccessState extends SocialState{}

class SocialGetMessagesSuccessState extends SocialState{}
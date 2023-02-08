import 'package:facetook/layout/social_layouts/social_cubit/cubit.dart';
import 'package:facetook/layout/social_layouts/social_cubit/state.dart';
import 'package:facetook/shared/components/components.dart';
import 'package:facetook/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {

    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {

        var userModel = SocialCubit.get(context).userModel;
        var profileImage =  SocialCubit.get(context).profileImage;
        var coverImage =  SocialCubit.get(context).coverImage;

        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            action: [
              defaultTextBottom(
                function: () {
                  SocialCubit.get(context).updateUser(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                text: 'update',
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(state is SocialUpdateUserLoadingState)
                    const LinearProgressIndicator(),
                  if(state is SocialUpdateUserLoadingState)
                    const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 145.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      4.0,
                                    ),
                                    topRight: Radius.circular(
                                      4.0,
                                    ),
                                  ),
                                  image: DecorationImage(
                                    image:coverImage == null ? NetworkImage(
                                      '${userModel.covers}',
                                    ) : FileImage(coverImage) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: const CircleAvatar(
                                  child: Icon(
                                    IconBroken.Camera,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                backgroundImage:profileImage == null ? NetworkImage(
                                  '${userModel.images}',
                                ) : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar(
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  if(SocialCubit.get(context).profileImage != null ||SocialCubit.get(context).coverImage != null )
                    Row(
                    children: [
                        if(SocialCubit.get(context).profileImage != null)
                          Expanded(
                        child: Column(
                          children: [
                            defaultBottom(
                              function: (){
                                SocialCubit.get(context).uploadProfileImage(
                                name: nameController.text,
                                bio: bioController.text,
                                phone: phoneController.text,
                              );},
                              text: 'upload profile',
                            ),
                            if(state is SocialUpdateUserLoadingState)
                              const SizedBox(
                                height: 4.0,
                              ),
                            if(state is SocialUpdateUserLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      if(SocialCubit.get(context).coverImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultBottom(
                              function: (){
                                SocialCubit.get(context).uploadCoverImage(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                              text: 'upload cover',
                            ),
                            if(state is SocialUpdateUserLoadingState)
                              const SizedBox(
                              height: 4.0,
                            ),
                            if(state is SocialUpdateUserLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(SocialCubit.get(context).profileImage != null ||SocialCubit.get(context).coverImage != null )
                    const SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'name must\'t be empty';
                      }
                    },
                    label: 'Name',
                    preifix: IconBroken.User,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'bio must\'t be empty';
                      }
                    },
                    label: 'Bio',
                    preifix: IconBroken.Info_Circle,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'phone number must\'t be empty';
                      }
                    },
                    label: 'Phone',
                    preifix: IconBroken.Call,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:facetook/layout/social_layouts/social_cubit/cubit.dart';
import 'package:facetook/layout/social_layouts/social_cubit/state.dart';
import 'package:facetook/model/social_user_model/message_model.dart';
import 'package:facetook/model/social_user_model/social_user_model.dart';
import 'package:facetook/shared/style/colors.dart';
import 'package:facetook/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageDetailsScreen extends StatelessWidget {

  SocialUserModel? userModel;
  MessageDetailsScreen({this.userModel});

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
     builder: (BuildContext context){
       SocialCubit.get(context).getMessages(receiverId: userModel!.uId!);
       return BlocConsumer<SocialCubit, SocialState>(
         listener: (context, state) {},
         builder: (context, state) {
           return Scaffold(
             appBar: AppBar(
               titleSpacing: 0.0,
               title: Row(
                 children: [
                   CircleAvatar(
                     radius: 25.0,
                     backgroundImage: NetworkImage(
                       userModel!.images!,
                     ),
                   ),
                   const SizedBox(
                     width: 10.0,
                   ),
                   Text(
                     userModel!.name!,
                   ),
                 ],
               ),
             ),
             body: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 children: [
                   Expanded(
                     child: ListView.separated(
                       itemBuilder: (context, index) {
                         var message = SocialCubit.get(context).messages[index];

                         if(SocialCubit.get(context).userModel!.uId == message.senderId) {
                           return buildMyMessage(message);
                         } else{
                           return buildMessage(message);
                         }
                       },
                       separatorBuilder: (context, index) => const SizedBox(
                         height: 15.0,
                       ),
                       itemCount: SocialCubit.get(context).messages.length,
                     ),
                   ),
                   Container(
                     decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey.withOpacity(0.2),
                           width: 1.0,
                         ),
                         borderRadius: BorderRadius.circular(15.0)
                     ),
                     clipBehavior: Clip.antiAliasWithSaveLayer,
                     child: Row(
                       children: [
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.symmetric(
                               horizontal: 15.0,
                             ),
                             child: TextFormField(
                               controller: messageController,
                               decoration: const InputDecoration(
                                 border: InputBorder.none,
                                 hintText: 'Type your message here ...',
                               ),
                             ),
                           ),
                         ),
                         Container(
                           color: defaultColor,
                           width: 50.0,
                           child: MaterialButton(
                             onPressed: () {
                               SocialCubit.get(context).sendMessage(
                                 receiverId: userModel!.uId!,
                                 dateTime: DateTime.now().toString(),
                                 text: messageController.text,
                               );
                             },
                             minWidth: 1.0,
                             child: const Icon(
                               IconBroken.Send,
                               size: 16.0,
                               color: Colors.white,
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           );
         },
       );
     },
    );
  }

  Widget buildMessage(MessageModel message) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration:  BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          )
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        message.text!,
      ),
    ),
  );

  Widget buildMyMessage(MessageModel message) =>  Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration:  BoxDecoration(
          color: defaultColor.withOpacity(0.2,),
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          )
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        message.text!,
      ),
    ),
  );
}

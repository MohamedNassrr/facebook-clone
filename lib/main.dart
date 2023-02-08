import 'package:facetook/bloc_observer.dart';
import 'package:facetook/layout/social_layouts/social_cubit/cubit.dart';
import 'package:facetook/layout/social_layouts/social_layout.dart';
import 'package:facetook/modules/login_screen/login_screen.dart';
import 'package:facetook/shared/components/components.dart';
import 'package:facetook/shared/components/constants.dart';
import 'package:facetook/shared/network/local/cache_helper.dart';
import 'package:facetook/shared/network/remote/dio_helper.dart';
import 'package:facetook/shared/style/themes.dart';
import 'package:facetook/shared/themecubit/cubit.dart';
import 'package:facetook/shared/themecubit/states.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print('background');
  print(message.data.toString());
  showToast(text: 'onabackground', state: ToastStates.SUCCESS);
}

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();

  print(token);

  // foreGround FCM
  FirebaseMessaging.onMessage.listen((event) {
    print('onMessage');
    print(event.data.toString());
    showToast(text: 'onMessage', state: ToastStates.SUCCESS);
  });

  // When click on notification to open app FCM
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('onMessageOpenedApp');
    print(event.data.toString());
    showToast(text: 'onMessageOpenedApp', state: ToastStates.SUCCESS);
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  BlocOverrides.runZoned(
    () async {
      DioHelper.init();
      await CacheHelper.init();

      Widget widget;
      uId = CacheHelper.getData(key: 'uId');

      if (uId != null) {
        widget = SocialLayout();
      } else {
        widget = SocialLoginScreen();
      }

      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => themeCubit()..changeAppMode(),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUserData()..getPost(),
        ),
      ],
      child: BlocConsumer<themeCubit, ThemeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}

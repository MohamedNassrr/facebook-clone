import 'package:facetook/modules/login_screen/login_screen.dart';
import 'package:facetook/shared/components/components.dart';
import 'package:facetook/shared/network/local/cache_helper.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if(value){
       navigateAndFinish(context, SocialLoginScreen());
    }
  });
}
void printFullText(String? text)
{
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text!).forEach((match) => print(match.group(0)));
}

String? uId = '';
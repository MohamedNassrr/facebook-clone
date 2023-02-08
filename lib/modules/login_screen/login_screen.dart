import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:facetook/layout/social_layouts/social_layout.dart';
import 'package:facetook/modules/login_screen/login_cubit/cubit.dart';
import 'package:facetook/modules/login_screen/login_cubit/state.dart';
import 'package:facetook/modules/register_screen/register_screen.dart';
import 'package:facetook/shared/components/components.dart';
import 'package:facetook/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            );
            navigateAndFinish(
              context,
              SocialLayout(),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Facetook'),
            ),
            body: Container(
              color: Colors.white30,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 10.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                  // -----email form field
                                  defaultFormField(
                                    controller: emailController,
                                    type: TextInputType.emailAddress,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Email address is valid!';
                                      }
                                    },
                                    label: 'Email Address',
                                    preifix: Icons.email_outlined,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  // -----password form field
                                  defaultFormField(
                                      controller: passwordController,
                                      type: TextInputType.visiblePassword,
                                      isPassword: LoginCubit.of(context).isPassword,
                                      onSubmit: (value) {
                                        if (formKey.currentState!.validate()) {
                                          LoginCubit.of(context).userLogin(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return 'password is too short';
                                        }
                                      },
                                      label: 'Password',
                                      preifix: Icons.lock_outline,
                                      suffix: LoginCubit.of(context).suffix,
                                      suffixPressed: () {
                                        LoginCubit.of(context)
                                            .changePasswordVisibilty();
                                      }),
                                  // ----- end of password form-field
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                ConditionalBuilder(
                                  condition: state is! LoginLoadingState,
                                  builder: (context) => defaultBottom(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        LoginCubit.of(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                    },
                                    text: 'login',
                                    isUpperCase: true,
                                  ),
                                  fallback: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have an account',
                                    ),
                                    defaultTextBottom(
                                      function: () {
                                        navigateTo(context, RegisterScreen());
                                      },
                                      text: 'REGISTER',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

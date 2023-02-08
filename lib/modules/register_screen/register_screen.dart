import 'package:facetook/layout/social_layouts/social_layout.dart';
import 'package:facetook/modules/register_screen/register_cubit/cubit.dart';
import 'package:facetook/modules/register_screen/register_cubit/state.dart';
import 'package:facetook/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),

      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if(state is RegisterCreateUserSuccessState){
            navigateAndFinish(context, SocialLayout());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
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
                                    'Register',
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
                                  // ----- user-form-field
                                  defaultFormField(
                                    controller: nameController,
                                    type: TextInputType.text,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'name must\'t be empty';
                                      }
                                    },
                                    label: 'Username',
                                    preifix: Icons.person,
                                  ),
                                  // ----- end of user-form-field
                                  SizedBox(
                                    height: 20.0,
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
                                  // ----- end of email-text-form-field
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  // ----- phone-form-filed
                                  defaultFormField(
                                    controller: phoneController,
                                    type: TextInputType.phone,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Incorrect phone number';
                                      }
                                    },
                                    label: 'Phone number',
                                    preifix: Icons.phone,
                                  ),
                                  // ----- end-phone-form-filed
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  // -----password form field
                                  defaultFormField(
                                    controller: passwordController,
                                    type: TextInputType.visiblePassword,
                                    isPassword:
                                        RegisterCubit.get(context).isPassword,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'password is too short';
                                      }
                                    },
                                    label: 'Password',
                                    preifix: Icons.lock_outline,
                                    suffix: RegisterCubit.get(context).suffix,
                                    suffixPressed: () {
                                      RegisterCubit.get(context)
                                          .ChangePasswordVisibilty();
                                    },
                                  ),
                                  // ----- end of password form-field
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                defaultBottom(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      RegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  text: 'register',
                                  isUpperCase: true,
                                ),
                                SizedBox(
                                  height: 20.0,
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

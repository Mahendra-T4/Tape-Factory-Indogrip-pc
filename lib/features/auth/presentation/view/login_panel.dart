import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:indogrip/features/auth/presentation/view/forgot_password.dart';

class IndoGripLoginPanel extends StatefulWidget {
  const IndoGripLoginPanel({super.key});
  static const String routeName = '/IndoGripLoginPanel';

  @override
  State<IndoGripLoginPanel> createState() => _IndoGripLoginPanelState();
}

class _IndoGripLoginPanelState extends State<IndoGripLoginPanel> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isShow = true;
  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = AuthBloc();
    super.initState();
  }

  void _handleLogin() {
    final formState = _formKey.currentState;
    if (formState != null) {
      bool isValid = formState.validate();

      if (_emailController.text.isEmpty) {
        FocusScope.of(context).requestFocus(emailFocusNode);
      } else if (_emailController.text.isNotEmpty &&
          !RegExp(
            r'^(([^<>()[\]\\.,;:\s@]+(\.[^<>()[\]\\.,;:\s@]+)*)|(.+))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$',
          ).hasMatch(_emailController.text)) {
        FocusScope.of(context).requestFocus(emailFocusNode);
      } else if (_passwordController.text.isEmpty) {
        FocusScope.of(context).requestFocus(passwordFocusNode);
      }

      if (isValid) {
        formState.save();
        _authBloc.add(
          AuthTFourUserLoginEvent(
            email: _emailController.text,
            password: _passwordController.text,
            context: context,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InternetConnectionService().connectionStream,
        initialData: true, // Assume connected initially
        builder: (context, snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return const NoInternetConnection();
          }

          // Handle disconnected state
          if (snapshot.data == false) {
            return const NoInternetConnection();
          }

          // Handle loading state
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
        return Scaffold(
          body: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 700) {
                  // Desktop layout
                  return _buildDesktopLayout();
                } else {
                  // Mobile layout
                  return _buildMobileLayout();
                }
              },
            ),
          ),
        );
      }
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                padding: EdgeInsets.all(20),
                color: Color(0xffE8E8F1),
              ),
              Image.asset("assets/images/login.png", height: 500, width: 500),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(Assets.indoGripLogoImage, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 50, right: 50),
                child: SizedBox(width: 460.0, child: _buildFormFields('Email')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 50, right: 50),
                child: SizedBox(
                  width: 460.0,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: isShow,
                    focusNode: passwordFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required to login.";
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: "Your Password",
                      labelStyle: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          isShow ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        onTap: () {
                          setState(() {
                            isShow = !isShow;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.indigoAccent,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onFieldSubmitted: (_) => _handleLogin(),
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50, right: 50),
                width: 460,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(ForgotPasswordPanel.routeName);
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              loginButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget loginButton() {
    return BlocConsumer(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthTFourLoginSuccessState) {
          if (state.user.status == 1) {
            ToastService.instance.showSuccess(
              context,
              state.user.message.toString(),
            );
          } else {
            ToastService.instance.showError(
              context,
              state.user.message.toString(),
            );
          }
        }
        if (state is AuthTFourLoginErrorState) {
          ToastService.instance.showError(context, state.error.toString());
        }
      },
      builder: (context, state) {
        if (state is AuthTFourLoadingStatus) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is AuthTFourLoginErrorState) {
          return const Center(child: Text("Login Failed"));
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: kButtonColor,
            minimumSize: const Size(470, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _handleLogin,
          child: Text(
            "Log In",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Image.asset(
            'assets/images/tfour_tech_pvt_ltd_logo-removebg-preview.png',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            "Welcome Back",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 50, right: 50),
          child: SizedBox(
            width: 460.0,
            child: TextFormField(
              controller: _emailController,
              focusNode: emailFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(passwordFocusNode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required to login.";
                } else if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return "Please enter a valid email address.";
                }
                return null;
              },
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: "Your Email",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.indigoAccent, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.red[400]!, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 50, right: 50),
          child: SizedBox(
            width: 460.0,
            child: TextFormField(
              controller: _passwordController,
              obscureText: isShow,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Password is required to login.";
                }
                return null;
              },
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: "Your Password",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                suffixIcon: InkWell(
                  child: Icon(
                    isShow ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  onTap: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.indigoAccent,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.red[400]!, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onFieldSubmitted: (_) => _handleLogin(),
            ),
          ),
        ),
        SizedBox(
          width: 400,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: InkWell(
                onTap: () {
                  context.pushNamed(ForgotPasswordPanel.routeName);
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        loginButton(),
      ],
    );
  }

  Widget _buildFormFields(String labeltext) {
    return SizedBox(
      width: 460.0,
      child: TextFormField(
        controller: _emailController,
        focusNode: emailFocusNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(passwordFocusNode),
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your email id.";
          }
          // else if (value.isNotEmpty &&
          //     !RegExp(
          //       r'^(([^<>()[\]\\.,;:\s@]+(\.[^<>()[\]\\.,;:\s@]+)*)|(.+))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$',
          //     ).hasMatch(value)) {
          //   return "Enter a valid email id.";
          // }
          else {
            return null;
          }
        },
        style: const TextStyle(
          fontFamily: "Montserrat",
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 15,
            color: Colors.grey[600],
          ),
          filled: true,
          fillColor: Colors.grey[50],
          prefixIcon: const Icon(Icons.email_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.indigoAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red[400]!, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

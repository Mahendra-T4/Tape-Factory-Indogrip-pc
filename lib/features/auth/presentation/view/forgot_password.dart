import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indogrip/core/responsive/responsive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/core/utils/widgets/button.dart';
import 'package:indogrip/core/utils/widgets/toast_service.dart';
import 'package:indogrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ForgotPasswordPanel extends StatefulWidget {
  static const String routeName = '/forgot-password';

  const ForgotPasswordPanel({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPanel> createState() => _ForgotPasswordPanelState();
}

class _ForgotPasswordPanelState extends State<ForgotPasswordPanel> {
  final _formKey = GlobalKey<FormState>();
  late final AuthBloc _authBloc;
  final _emailController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[50]!, Colors.white],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: ResponsiveBuilder(
                  builder: (context, sizingInformation) {
                    double containerWidth = sizingInformation.isDesktop
                        ? 500
                        : sizingInformation.isTablet
                        ? 450
                        : MediaQuery.of(context).size.width * 0.9;

                    return Container(
                      width: containerWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo and Title
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/indogrip-logo.png',
                                  height: 80,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Enter your email address and we\'ll send you instructions to reset your password.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'Enter your email address',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.blue[300],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.blue[300]!,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                // if (!RegExp(Regex.email).hasMatch(value)) {
                                //   return 'Please enter a valid email address';
                                // }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            submitButton,
                            const SizedBox(height: 20),

                            // Back to Login
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Back to Login',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get submitButton => BlocConsumer(
    bloc: _authBloc,
    listener: (context, state) {
      if (state is AuthForgotPasswordSuccessState) {
        if (state.forgotPasswordEntity.status == 1) {
          if (context.mounted) {
            ToastService.instance.showSuccess(
              context,
              state.forgotPasswordEntity.message.toString(),
            );
          }
        } else {
          if (context.mounted) {
            ToastService.instance.showError(
              context,
              state.forgotPasswordEntity.message.toString(),
            );
          }
        }
      }
      if (state is AuthForgotPasswordErrorState) {
        if (context.mounted) {
          ToastService.instance.showError(context, state.error);
        }
      }
    },
    builder: (context, state) {
      if (state is AuthTFourLoadingStatus) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [CircularProgressIndicator()],
        );
      }
      return Row(
        children: [
          if (Responsive.isDesktop(context)) Expanded(child: SizedBox()),
          // Expanded(child: SizedBox()),
          // Expanded(child: SizedBox()),
          Expanded(
            child: CustomButton(
              label: isSubmitting ? 'Sending...' : 'Send Reset Link',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _authBloc.add(
                    AuthForgotPasswordEvent(
                      email: _emailController.text.trim(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );
    },
  );
}

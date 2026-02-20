import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indogrip/Assets/assets.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/core/service/connectivity/not_connected.dart';
import 'package:indogrip/features/auth/presentation/view/setpassword.dart';


//import 'package:flutter/services.dart';

class Otpverification extends StatefulWidget {
  const Otpverification({super.key});
  static const String routeName = '/opt-verification';

  @override
  State<Otpverification> createState() => _OtpverificationState();
}

class _OtpverificationState extends State<Otpverification> {
  TextEditingController text1 = TextEditingController();
  TextEditingController text2 = TextEditingController();
  TextEditingController text3 = TextEditingController();
  TextEditingController text4 = TextEditingController();
  TextEditingController text5 = TextEditingController();
  TextEditingController text6 = TextEditingController();
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
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 120),
                  Container(
                      clipBehavior: Clip.antiAlias,
                      height: 150,
                      width: 150,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child:
                          Image.asset(Assets.indoGripLogoImage, fit: BoxFit.cover)),
                  Text(
                    'OTP Verification',
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      myInputBox(context, text1),
                      myInputBox(context, text2),
                      myInputBox(context, text3),
                      myInputBox(context, text4),
                      myInputBox(context, text5),
                      myInputBox(context, text6),
                    ],
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('Resend OTP in: 0:18'),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size(360, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Colors.indigoAccent),
                        onPressed: () {
                          GoRouter.of(context).goNamed(SetPassword.routeName);
                        },
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 20),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

Widget myInputBox(BuildContext context, TextEditingController controller) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      border: Border.all(width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
    ),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      //maxLength: 1,
      style: const TextStyle(fontSize: 28),
    ),
  );
}

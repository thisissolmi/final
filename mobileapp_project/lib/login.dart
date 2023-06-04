import 'package:flutter/material.dart';
import 'app/appstate.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: loginlog
              ),
            ),
            const SizedBox(height: 120.0),
            const SizedBox(height: 12.0),
            const GoogleLoginButton(),
            const SizedBox(height: 12.0),
            const AnonymousLoginButton(),
          ],
        )

      ),
    );  
  }
   Column loginlog  = Column(
    children: <Widget>[
      Image.asset('assets/images/mainlog.png'),
      const SizedBox(height: 16.0),
    ],
  );
}

//google login buuton
class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppStatement appstate = AppStatement();

    return SignInButton(
      Buttons.Google,
      onPressed: () async {
        final usercredential = await appstate.signInWithGoogle();
        if(usercredential != null){
          Navigator.pushNamed(context, '/');
        }else{
          print('login error');
        }
      },
    );
  }
}
//anonymous login button
class AnonymousLoginButton extends StatelessWidget {
  const AnonymousLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppStatement appstate = AppStatement();

  return SignInButtonBuilder(
    text: 'Guest',
    icon: Icons.account_balance,
    onPressed: () async{
       final usercredential = await appstate.signInWithAnonymously();
        if(usercredential != null){
          Navigator.pushNamed(context, '/');
        }else{
          print('login error');
        }
    },
    backgroundColor: Colors.blueGrey[700]!,
  );
  }
}
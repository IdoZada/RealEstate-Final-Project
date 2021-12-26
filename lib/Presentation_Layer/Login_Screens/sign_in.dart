import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/Shared/components.dart';
import 'package:real_estate/Utils/exceptions/auth_exceptions.dart';
import 'package:real_estate/Utils/my_style.dart';
import 'package:real_estate/Utils/system_consts.dart';
import 'package:real_estate/Data_Access/auth.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Login extends StatefulWidget {
  final Function toggleView;

  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();

  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String errorPassword = '';
  String error = '';

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Form(
            key: _formKeyEmail,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: 'Enter your Email',
                hintStyle: kHintTextStyle,
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "Required *"),
                EmailValidator(errorText: "Not a Valid Email"),
              ]),
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  String validatePass(value) {
    setState(() {
      error = '';
    });
    if (value.isEmpty) {
      return Consts.ERR_REQUIRED_MSG;
    } else if (value.length < 6) {
      return Consts.ERR_SHOULD_SIX_CHAR_MSG;
    } else if (value.length > 15) {
      return Consts.ERR_SHOULD_FIFTY_CHAR_MSG;
    } else {
      return null;
    }
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Form(
            key: _formKeyPassword,
            child: TextFormField(
              obscureText: true,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle,
              ),
              validator: validatePass,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: loading
          ? getLoader()
          : ElevatedButton(
              // elevation: 5.0,
              style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith<double>(
                      (states) => 5.0),
                  padding: MaterialStateProperty.resolveWith<EdgeInsets>(
                      (states) => EdgeInsets.all(15.0)),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                          (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => Colors.white,
                  )),
              onPressed: () async {
                // Validate returns true if the form is valid, otherwise false.
                if (_formKeyEmail.currentState.validate() &&
                    _formKeyPassword.currentState.validate()) {
                  // If the form is valid
                  // call the sign in method in auth service class

                  setState(() {
                    error = '';
                    loading = true;
                  });

                  dynamic result =
                      await _auth.signInWithEmailAndPassword(email, password);
                  final errorMsg =
                      AuthExceptionHandler.generateExceptionMessage(
                          _auth.authErrorMessage);
                  print(errorMsg);

                  if (result == null) {
                    // sign in failed
                    setState(() {
                      error = errorMsg;
                      loading = false;
                    });
                  }
                }
              },
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => this.widget.toggleView(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        _buildLoginBtn(),
                        Text(
                          error,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

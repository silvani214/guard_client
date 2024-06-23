import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/auth_password_field.dart';
import 'package:guard_client/ui/widgets/logo.dart'; // Import the common logo widget
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            final snackBar = SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Sign In',
                message: state.error,

                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                contentType: ContentType.failure,
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          bool isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(child: Logo()),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Text(
                    'Sign in to Your Account',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Roboto', // You can also use 'Arial'
                      fontSize: 24, // Adjust the font size as needed
                      fontWeight: FontWeight
                          .bold, // Adjust the font weight if necessary
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.15),
                AuthTextField(
                  controller: userNameController,
                  label: 'Email',
                  icon: Icons.person,
                  hintText: 'Your Email Address',
                ),
                SizedBox(height: 16),
                AuthPasswordField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  hintText: 'Your Password',
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? () => {}
                        : () {
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginEvent(
                                username: userNameController.text,
                                password: passwordController.text,
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Rounded corners
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 19,
                            height: 19,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text('Login'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

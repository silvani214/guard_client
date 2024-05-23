import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/auth_password_field.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * .08),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    'assets/logo.jpg',
                    height: 60, // Adjust the height as needed
                  )
                ]),
                SizedBox(height: screenHeight * .08),
                AuthTextField(
                  controller: userNameController,
                  label: 'Email',
                  icon: Icons.person,
                ),
                SizedBox(height: 16),
                AuthPasswordField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(
                        LoginEvent(
                          username: userNameController.text,
                          password: passwordController.text,
                        ),
                      );
                    },
                    child: Text('Login'),
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

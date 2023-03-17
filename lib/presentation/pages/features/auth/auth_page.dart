import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_snack_bar.dart';
import 'package:tocopedia/presentation/providers/local_settings_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

enum AuthFormMode { signUp, login }

class AuthPage extends StatefulWidget {
  static const String routeName = '/auth';

  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).autoLogin();
    });
  }

  final _authFormKey = GlobalKey<FormState>();
  AuthFormMode _formMode = AuthFormMode.login;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void submitForm(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_authFormKey.currentState!.validate()) {
      if (_formMode == AuthFormMode.login) {
        await userProvider.login(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else if (_formMode == AuthFormMode.signUp) {
        await userProvider.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );
      }
    }
    //show error message
    if (userProvider.authState == ProviderState.error) {
      if (context.mounted) {
        showCustomSnackBar(context, message: userProvider.message);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, value, child) {
            if (value.autoLoginState == ProviderState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          _formMode == AuthFormMode.signUp
                              ? "Sign Up"
                              : "Login",
                          style: theme.textTheme.displayMedium!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15).copyWith(top: 0),
                          child: Form(
                              key: _authFormKey,
                              child: Column(
                                children: [
                                  if (_formMode == AuthFormMode.signUp)
                                    TextFormField(
                                      key: const Key("name_field"),
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person_rounded),
                                        hintText: 'Name',
                                        labelText: 'Name',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please input your name';
                                        }
                                        return null;
                                      },
                                    ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    key: const Key("email_field"),
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.email_rounded),
                                      hintText: 'Email Address',
                                      labelText: 'Email',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please input your email';
                                      }
                                      final bool emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!emailValid) {
                                        return 'Please enter valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    key: const Key("password_field"),
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.key_rounded),
                                      hintText: 'Min. 8 characters',
                                      labelText: 'Password',
                                    ),
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please input your password';
                                      }
                                      if (value.length < 8) {
                                        return 'Please enter password longer than 8 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              )),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FilledButton(
                        onPressed: () => submitForm(context),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                              40), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        child: Consumer<UserProvider>(
                            builder: (context, value, child) {
                          if (value.authState == ProviderState.loading) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: theme.scaffoldBackgroundColor,
                            ));
                          }
                          return Text(
                            _formMode == AuthFormMode.signUp
                                ? "Sign Up"
                                : "Login",
                            style: const TextStyle(
                              fontSize: 20.0, // insert your font size here
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_formMode == AuthFormMode.signUp
                              ? "Already have an account? "
                              : "Don't have an account? "),
                          if (_formMode == AuthFormMode.signUp)
                            GestureDetector(
                              onTap: () => setState(
                                  () => _formMode = AuthFormMode.login),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor),
                              ),
                            ),
                          if (_formMode == AuthFormMode.login)
                            GestureDetector(
                              onTap: () => setState(
                                  () => _formMode = AuthFormMode.signUp),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => Provider.of<LocalSettingsProvider>(context,
                                listen: false)
                            .switchToGuestMode(),
                        child: const Text("Continue as Guest",
                            style: TextStyle(color: Colors.black38)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

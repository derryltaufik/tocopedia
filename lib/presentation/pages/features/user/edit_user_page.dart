import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

class EditUserPage extends StatefulWidget {
  static const String routeName = '/users/edit';

  const EditUserPage({Key? key}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _editUserFormKey = GlobalKey<FormState>();

  void submitForm(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_editUserFormKey.currentState!.validate()) {
      await userProvider.updateUser(
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
      );
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();

      if (userProvider.updateUserState == ProviderState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userProvider.message),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Edit Profile Success"),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider
        .of<UserProvider>(context, listen: false)
        .user!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 100),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(30).copyWith(top: 0),
                  child: Form(
                      key: _editUserFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            key: Key("name_field"),
                            controller: _nameController..text = user.name,
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
                          SizedBox(height: 10),
                          // TextFormField(
                          //   key: Key("password_field"),
                          //   // controller: _passwordController,
                          //   decoration: const InputDecoration(
                          //     icon: Icon(Icons.key_rounded),
                          //     hintText: 'Min. 8 characters',
                          //     labelText: 'Password',
                          //   ),
                          //   textInputAction: TextInputAction.done,
                          //   keyboardType: TextInputType.visiblePassword,
                          //   obscureText: true,
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please input your password';
                          //     }
                          //     if (value.length < 8) {
                          //       return 'Please enter password longer than 8 characters';
                          //     }
                          //     return null;
                          //   },
                          // ),
                        ],
                      )),
                ),
                FilledButton(
                  onPressed: () => submitForm(context),
                  child:
                  Consumer<UserProvider>(builder: (context, value, child) {
                    if (value.updateUserState == ProviderState.loading) {
                      return CircularProgressIndicator(
                        color: theme.scaffoldBackgroundColor,
                      );
                    }
                    return Text("Save Changes");
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

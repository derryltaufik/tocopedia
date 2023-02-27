import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_snack_bar.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

class EditUserPage extends StatefulWidget {
  static const String routeName = '/users/edit';

  const EditUserPage({Key? key}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final _editUserFormKey = GlobalKey<FormState>();

  void submitForm(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_editUserFormKey.currentState!.validate()) {
      await userProvider.updateUser(
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
      );
    }
    if (context.mounted) {
      if (userProvider.updateUserState == ProviderState.error) {
        showCustomSnackBar(context,
            message: userProvider.message, color: Colors.red);
      } else {
        showCustomSnackBar(context, message: "Edit Profile Success");
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user!;
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
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                      key: _editUserFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            key: Key("name_field"),
                            controller: _nameController..text = user.name!,
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

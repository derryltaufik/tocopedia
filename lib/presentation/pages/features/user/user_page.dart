import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/pages/features/address/view_all_addresses_page.dart';
import 'package:tocopedia/presentation/pages/features/user/edit_user_page.dart';
import 'package:tocopedia/presentation/providers/local_settings_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';
import 'package:intl/intl.dart';

class UserPage extends StatelessWidget {
  static const String routeName = "/users";

  const UserPage({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    await handleFutureFunction(
      context,
      function: Provider.of<UserProvider>(context, listen: false).logout(),
      loadingMessage: "Logging out...",
      successMessage: "Logged out",
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, value, child) {
            final user = value.user!;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle, size: 100),
                    const SizedBox(height: 30),
                    Text(user.name!,
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      user.email!,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Member Since ${DateFormat('d MMMM y').format(user.createdAt!)}",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(EditUserPage.routeName),
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text("Edit Profile"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(ViewAllAddressesPage.routeName),
                      icon: const Icon(Icons.home_rounded),
                      label: const Text("Manage Address"),
                    ),
                    const SizedBox(height: 30),
                    TextButton.icon(
                      onPressed: () => logout(context),
                      label: const Text("Logout"),
                      icon: const Icon(Icons.logout_rounded),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton:
          Consumer<LocalSettingsProvider>(builder: (context, value, child) {
        if (value.appMode == AppMode.buyer) {
          return FilledButton(
              child: const Text("Switch to Seller Mode"),
              onPressed: () => value.switchToSellerMode());
        } else if (value.appMode == AppMode.seller) {
          return FilledButton(
              child: const Text("Switch to Buyer Mode"),
              onPressed: () => value.switchToBuyerMode());
        }
        return const SizedBox.shrink();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
// : const Text("Switch to Buyer Mode")

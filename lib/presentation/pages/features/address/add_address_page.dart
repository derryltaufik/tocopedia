import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/providers/address_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

class AddAddressPage extends StatefulWidget {
  static const String routeName = "addresses/add";

  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _addAddressFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _labelController = TextEditingController();
  final _completeAddressController = TextEditingController();
  final _notesController = TextEditingController();
  bool setAsDefault = false;

  Future<void> submitForm(BuildContext context) async {
    if (_addAddressFormKey.currentState!.validate()) {
      final Address? address = await handleFutureFunction(
        context,
        successMessage: "Address added successfully!",
        function:
            Provider.of<AddressProvider>(context, listen: false).addAddress(
          completeAddress: _completeAddressController.text,
          receiverName: _nameController.text,
          receiverPhone: _phoneNumberController.text,
          notes: _notesController.text,
          label: _labelController.text,
        ),
      );
      if (setAsDefault && address != null && context.mounted) {
        await Provider.of<UserProvider>(context, listen: false)
            .updateUser(addressId: address.id);
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _labelController.dispose();
    _completeAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addAddressFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  maxLength: 50,
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Receiver Name"),
                  textInputAction: TextInputAction.next,
                  validator: (value) => minLengthValidator(value, 2),
                ),
                TextFormField(
                  maxLength: 15,
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Start with 0 or 62"),
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Must be filled';
                    }
                    const minLength = 9;
                    if (value.length < minLength) {
                      return "Too short, min. $minLength characters";
                    }
                    if (!(value.startsWith("0") || value.startsWith("62"))) {
                      return "Phone number must start with 0 or 62";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLength: 30,
                  controller: _labelController,
                  decoration: const InputDecoration(labelText: "Address Label"),
                  textInputAction: TextInputAction.next,
                  validator: (value) => minLengthValidator(value, 3),
                ),
                TextFormField(
                  maxLength: 200,
                  controller: _completeAddressController,
                  decoration: const InputDecoration(labelText: "Full Address"),
                  textInputAction: TextInputAction.next,
                  validator: (value) => minLengthValidator(value, 3),
                ),
                TextFormField(
                  maxLength: 45,
                  controller: _notesController,
                  decoration: const InputDecoration(
                      labelText: "Notes For Courrier (Optional)",
                      helperText:
                          "House color, landmarks, special message, etc."),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                //TODO change to customformfield
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        value: setAsDefault,
                        onChanged: (value) =>
                            setState(() => setAsDefault = value!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("Set as default address",
                        style: theme.textTheme.bodyLarge)
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: FilledButton(
                            onPressed: () => submitForm(context),
                            child: const Text("Submit"))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? minLengthValidator(String? value, int minLength) {
  if (value == null || value.isEmpty) {
    return 'Must be filled';
  }
  if (value.length < minLength) {
    return "Too short, min. $minLength characters";
  }
  return null;
}

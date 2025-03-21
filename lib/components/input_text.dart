import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final Icon icons;
  final TextFieldValidator validator;
  final TextInputType keyboardType;
  final Function(String) onChange;
  final bool disable;
  const InputText(
      {super.key,
      required this.label,
      required this.icons,
      required this.validator,
      required this.keyboardType,
      required this.onChange,
      required this.disable});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: disable,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        labelText: label,
        prefixIcon: icons,
      ),
      validator: validator.call,
      keyboardType: keyboardType,
      onChanged: onChange,
    );
  }
}

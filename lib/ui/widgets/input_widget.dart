import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class InputWidget extends StatefulWidget {
  const InputWidget(
      {super.key,
      required this.hint,
      this.icon,
      this.type,
      this.disabled = false,
      this.controller,
      this.validator,
      this.onChanged,
      this.onTap,  this.lines=1});

  final String hint;
  final IconData? icon;
  final TextInputType? type;
  final bool disabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final int lines;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool obscure = true;

  bool get isPassword => widget.type == TextInputType.visiblePassword;

  IconData get passwordIcon => obscure ? Iconsax.eye_slash : Iconsax.eye;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
maxLines: widget.lines,
      controller: widget.controller,
      keyboardType: widget.type ?? TextInputType.text,
      obscureText: isPassword ? obscure : false,
      readOnly: widget.disabled,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontWeight: FontWeight.w500),
        filled: true,
        hintText: widget.hint,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(10)),
        suffixIcon: widget.icon != null || isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                child: Icon(
                  isPassword ? passwordIcon : widget.icon,
                  color: Theme.of(context).hintColor,
                ))
            : null,
      ),
    );
  }
}

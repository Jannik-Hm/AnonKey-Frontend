import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  final bool enabled;
  final List<DropdownMenuItem<String>>? items;
  final String? preselectedValue;
  final Function(String? value)? onChangeCallback;

  const DropDownButton({
    super.key,
    this.enabled = true,
    this.items,
    this.preselectedValue,
    this.onChangeCallback,
  });

  @override
  State<StatefulWidget> createState() => _DropDownButton();
}

class _DropDownButton extends State<DropDownButton> {
  late bool _enabled;
  late String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = widget.enabled;
    selectedValue = widget.preselectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 5.0,
        right: 20.0,
        bottom: 5.0,
      ),
      //width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IgnorePointer(
            ignoring: !_enabled,
            child: DropdownButton(
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
                if (widget.onChangeCallback != null)
                  widget.onChangeCallback!(value);
              },
              dropdownColor: Theme.of(context).colorScheme.secondary,
              enableFeedback: true,
              iconEnabledColor: Theme.of(context).colorScheme.onSecondary,
              value: selectedValue,
              borderRadius: BorderRadius.circular(15),
              items: widget.items,
            ),
          ),
        ],
      ),
    );
  }
}

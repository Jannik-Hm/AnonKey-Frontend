import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' as iconpicker;
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IconPicker extends StatefulWidget {
  final void Function({required IconData? iconData})? iconCallback;
  final bool enabled;
  final IconData? iconData;

  const IconPicker({
    super.key,
    this.iconCallback,
    this.enabled = true,
    this.iconData,
  });

  @override
  State<StatefulWidget> createState() => _IconPicker();
}

class _IconPicker extends State<IconPicker> {
  late bool _enabled;
  IconData? _iconData;

  _pickIcon() async {
    iconpicker.IconPickerIcon? icon = await iconpicker.showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [iconpicker.IconPack.material],
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
    if(icon?.data == null) return;
    _iconData = icon?.data;
    setState(() {
      if(widget.iconCallback != null){
        widget.iconCallback!(iconData: icon?.data);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the mutable object from the widget field
    _enabled = widget.enabled;
    _iconData = widget.iconData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: (_iconData != null)
                ? Icon(
                    _iconData,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 40.0,
                  )
                : Container(),
          ),
          const SizedBox(width: 20.0),
          if (_enabled)
            TextButton(
              onPressed: _pickIcon,
              style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary),
              child: Text(AppLocalizations.of(context)!.chooseIcon),
            )
        ],
      ),
    );
  }
}

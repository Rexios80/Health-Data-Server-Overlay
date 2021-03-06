import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/settings.dart';

class SettingsTextField extends StatelessWidget {
  final Settings settings;

  final EditorType type;
  final bool spacer;

  SettingsTextField(this.type, this.settings, {Key? key, this.spacer = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: text);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Text(label),
              ] +
              (caption.isNotEmpty
                  ? [
                      SizedBox(height: 3),
                      Text(
                        caption,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ]
                  : []),
        ),
        Visibility(
          visible: spacer,
          child: Spacer(),
        ),
        Container(
          width: 200,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: save,
          ),
        ),
      ],
    );
  }

  String get text {
    switch (type) {
      case EditorType.clientName:
        return settings.clientName;
      case EditorType.port:
        return settings.port.toString();
      case EditorType.serverIp:
        return settings.serverIp;
      case EditorType.dataClearInterval:
        return settings.dataClearInterval.toString();
    }
  }

  String get label {
    switch (type) {
      case EditorType.clientName:
        return 'Client name';
      case EditorType.port:
        return 'WebSocket port';
      case EditorType.serverIp:
        return 'Server IP address';
      case EditorType.dataClearInterval:
        return 'Data clear interval (seconds)';
    }
  }

  String get caption {
    switch (type) {
      case EditorType.clientName:
        return 'Used to identify with other HDS overlays';
      default:
        return '';
    }
  }

  void save(String value) {
    switch (type) {
      case EditorType.clientName:
        settings.clientName = value;
        break;
      case EditorType.port:
        settings.port = int.tryParse(value) ?? 3476;
        break;
      case EditorType.serverIp:
        settings.serverIp = value;
        break;
      case EditorType.dataClearInterval:
        settings.dataClearInterval = int.tryParse(value) ?? 120;
        break;
    }

    settings.save();
  }
}

enum EditorType {
  clientName,
  port,
  serverIp,
  dataClearInterval,
}

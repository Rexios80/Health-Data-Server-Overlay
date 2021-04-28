import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/default_image.dart';

class WidgetEditor extends StatelessWidget {
  final EndDrawerController endDrawerController = Get.find();
  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    final properties =
        dwc.propertiesMap[endDrawerController.selectedDataType.value] ??
            DataWidgetProperties().obs;

    final header = Center(
      child: Text(
        EnumToString.convertToString(
          endDrawerController.selectedDataType.value,
          camelCase: true,
        ),
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );

    final positionEditor = Row(
      children: [
        Text('x: '),
        Container(
          width: 100,
          child: TextField(
            controller: TextEditingController(
                text: properties.value.position.item1.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              properties.value.position = Tuple2Double(
                double.tryParse(text) ?? 0.0,
                properties.value.position.item2,
              );
              saveAndRefresh(properties);
            },
          ),
        ),
        Spacer(),
        Text('y: '),
        Container(
          width: 100,
          child: TextField(
            controller: TextEditingController(
                text: properties.value.position.item2.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              properties.value.position = Tuple2Double(
                properties.value.position.item1,
                double.tryParse(text) ?? 0.0,
              );
              saveAndRefresh(properties);
            },
          ),
        ),
      ],
    );

    final imageEditor = Column(
      children: [
        Row(
          children: [
            Text('Show image'),
            Obx(
              () => Switch(
                value: properties.value.showImage,
                onChanged: (enabled) {
                  properties.value.showImage = enabled;
                  saveAndRefresh(properties);
                },
              ),
            ),
            Spacer(),
            Obx(() {
              if (properties.value.showImage &&
                  properties.value.image != null) {
                return InkWell(
                  onDoubleTap: () {
                    properties.value.image = null;
                    saveAndRefresh(properties);
                  },
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Remove'),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
            Spacer(),
            Obx(() {
              if (properties.value.showImage) {
                return InkWell(
                  onTap: () => selectImageFile(properties),
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Builder(builder: (context) {
                          final image = properties.value.image;
                          if (image == null) {
                            return Image.asset(
                                getDefaultImage(properties.value.dataType));
                          } else {
                            return Image.memory(image);
                          }
                        }),
                      ),
                    ),
                  ),
                );
              } else {
                // Prevent view shifting
                return SizedBox(width: 48, height: 48);
              }
            }),
            Spacer(),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text('Image size: '),
            Spacer(),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(
                  text: properties.value.imageSize.toString(),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  properties.value.imageSize = double.tryParse(value) ?? 0.0;
                  saveAndRefresh(properties);
                },
              ),
            ),
          ],
        ),
      ],
    );

    final textEditor = Column(
      children: [
        Row(
          children: [
            Text('Text size: '),
            Spacer(),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(
                  text: properties.value.fontSize.toString(),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  properties.value.fontSize = double.tryParse(value) ?? 0.0;
                  saveAndRefresh(properties);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text('Unit: '),
            Spacer(),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(
                  text: properties.value.unit,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  properties.value.unit = value;
                  saveAndRefresh(properties);
                },
              ),
            ),
          ],
        ),
        Builder(
          builder: (context) {
            var text = properties.value.unitFontSize.toString();
            return Obx(
              () {
                if (properties.value.unit.isEmpty) {
                  return SizedBox.shrink();
                } else {
                  final controller = TextEditingController(
                    text: text,
                  );
                  controller.selection =
                      TextSelection.collapsed(offset: controller.text.length);
                  return Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Unit text size: '),
                          Spacer(),
                          Container(
                            width: 100,
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                text = value;
                                properties.value.unitFontSize =
                                    double.tryParse(value) ?? 0.0;
                                saveAndRefresh(properties);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            );
          },
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text('Left padding: '),
            Spacer(),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(
                  text: properties.value.textPaddingLeft.toString(),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  properties.value.textPaddingLeft =
                      double.tryParse(value) ?? 0.0;
                  saveAndRefresh(properties);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text('Top padding: '),
            Spacer(),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(
                  text: properties.value.textPaddingTop.toString(),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  properties.value.textPaddingTop =
                      double.tryParse(value) ?? 0.0;
                  saveAndRefresh(properties);
                },
              ),
            ),
          ],
        ),
      ],
    );

    final deleteButton = InkWell(
      onDoubleTap: () {
        properties.value.delete();
        saveAndRefresh(properties);
        Get.back();
      },
      child: TextButton(
        onPressed: () {},
        child: Text('DELETE WIDGET'),
      ),
    );

    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        header,
        SizedBox(height: 20),
        Text(
          'Position',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        positionEditor,
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Text(
          'Image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        imageEditor,
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Text(
          'Text',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        textEditor,
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        deleteButton,
      ],
    );
  }

  void saveAndRefresh(Rx<DataWidgetProperties> properties) {
    try {
      properties.value.save();
    } catch (error) {
      // Don't save if the object got deleted
    }
    properties.refresh();
  }

  void selectImageFile(Rx<DataWidgetProperties> properties) async {
    final typeGroup =
        XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'gif']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    // Don't do anything if they don't pick a file
    if (file == null) return;

    properties.value.image = await file.readAsBytes();
    saveAndRefresh(properties);
  }
}

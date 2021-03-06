import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive/hive.dart';

part 'chart_widget_properties.g.dart';

@HiveType(typeId: 7)
class ChartWidgetProperties extends HiveObject {
  static const maxValuesToKeep = 500;

  @HiveField(0)
  DataType dataType = DataType.unknown;

  @HiveField(1)
  String dataSource = DataSource.watch;

  @HiveField(2)
  Tuple2Double position = Tuple2Double(275, 150);

  @HiveField(3)
  int rangeSeconds = 300;

  @HiveField(4)
  int? _highColor;

  Color get highColor => Color(_highColor ?? Colors.red.value);
  set highColor(Color color) => _highColor = color.value;

  @HiveField(5)
  int? _lowColor;

  Color get lowColor => Color(_lowColor ?? Colors.green.value);
  set lowColor(Color color) => _lowColor = color.value;
}

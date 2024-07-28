import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class LineChartExample extends StatelessWidget {
  final List<FlSpot> lineSpots;
  final double y;

  const LineChartExample({super.key, required this.lineSpots, required this.y});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: lineSpots,
                    isCurved: true,
                    barWidth: 2,
                    color: ColorsApp.mainColor,
                    belowBarData: BarAreaData(
                      show: true,
                      color: ColorsApp.mainColor.withOpacity(0.3),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        return Text(
                          value.toInt().toString(),
                          style: style,
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) {
                        Widget icon;
                        switch (value.toInt()) {
                          case 0:
                            icon = const Icon(OMIcons.home, size: 16);
                            break;
                          case 1:
                            icon = const Icon(OMIcons.peopleOutline, size: 16);
                            break;
                          case 2:
                            icon = const Icon(Icons.business, size: 16);
                            break;
                          case 3:
                            icon = const Icon(Icons.gesture, size: 16);
                            break;
                          case 4:
                            icon = const Icon(OMIcons.school, size: 16);
                            break;
                          case 5:
                            icon = const Icon(Icons.favorite_border, size: 16);
                            break;
                          case 6:
                            icon = const Icon(Icons.healing, size: 16);
                            break;
                          case 7:
                            icon = const Icon(OMIcons.headset, size: 16);
                            break;
                          case 8:
                            icon = const Icon(OMIcons.kitchen, size: 16);
                            break;
                          case 9:
                            icon = const Icon(OMIcons.announcement, size: 16);
                            break;
                          case 10:
                            icon = const Icon(OMIcons.wbSunny, size: 16);
                            break;
                          case 11:
                            icon = const Icon(OMIcons.localAtm, size: 16);
                            break;
                          default:
                            icon = const Text('');
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: icon,
                        );
                      },
                      interval: 1,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xffe7e8ec),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color(0xffe7e8ec),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xffe7e8ec),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: 12,
                minY: 0,
                maxY: y,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

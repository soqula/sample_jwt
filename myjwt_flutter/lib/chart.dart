import 'package:flutter/material.dart';
import './listbutton.dart';
import './jwtprovider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import './models.dart';
import './chartitem.dart';

class ChartList extends StatefulWidget {
  const ChartList({Key? key}) : super(key: key);
  @override
  _ChartListState createState() => _ChartListState();
}

class _ChartListState extends State<ChartList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JwtProvider>(builder: (context, jwtprovider, child) {
      if (jwtprovider.weightList.isEmpty) {
        return const Text('no data');
      } else {
        return Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: LineChart(
                LineChartData(
                  // タッチ操作時の設定
                  lineTouchData: const LineTouchData(
                    handleBuiltInTouches: true, // タッチ時のアクションの有無
                    getTouchedSpotIndicator:
                        defaultTouchedIndicators, // インジケーターの設定
                    touchTooltipData: LineTouchTooltipData(
                      // ツールチップの設定
                      getTooltipItems: defaultLineTooltipItem, // 表示文字設定
                      tooltipBgColor: Colors.white, // 背景の色
                      tooltipRoundedRadius: 2.0, // 角丸
                    ),
                  ),

                  // 背景のグリッド線の設定
                  gridData: FlGridData(
                    show: true, // 背景のグリッド線の有無
                    drawVerticalLine: true, // 水平方向のグリッド線の有無
                    horizontalInterval: 2.0, // 背景グリッドの横線間隔
                    verticalInterval: 2.0, // 背景グリッドの縦線間隔
                    getDrawingHorizontalLine: (value) {
                      // 背景グリッドの横線設定
                      return const FlLine(
                        color: Color.fromARGB(255, 47, 62, 73), // 背景横線の色
                        strokeWidth: 1.0, // 背景横線の太さ
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      // 背景グリッドの縦線設定
                      return const FlLine(
                        color: Color(0xff37434d), // 背景縦線の色
                        strokeWidth: 1.0, // 背景縦線の太さ
                      );
                    },
                  ),

                  // グラフのタイトル設定
                  titlesData: const FlTitlesData(
                      show: true, // タイトルの有無
                      bottomTitles: AxisTitles(
                        // 下側に表示するタイトル設定
                        axisNameWidget: Text(
                          "【日数】", // タイトル名
                          style: TextStyle(
                            color: Color(0xff68737d),
                          ),
                        ),
                        axisNameSize: 22.0, // タイトルの表示エリアの幅
                        sideTitles: SideTitles(
                          // サイドタイトル設定
                          showTitles: true, // サイドタイトルの有無
                          interval: 1.0, // サイドタイトルの表示間隔
                          reservedSize: 40.0, // サイドタイトルの表示エリアの幅
                          // getTitlesWidget: bottomTitleWidgets, // サイドタイトルの表示内容
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          // サイドタイトル設定
                          showTitles: true, // サイドタイトルの有無
                          interval: 5.0, // サイドタイトルの表示間隔
                          reservedSize: 40.0, // サイドタイトルの表示エリアの幅
                          // getTitlesWidget: bottomTitleWidgets, // サイドタイトルの表示内容
                        ),
                      ),
                      topTitles: AxisTitles(),
                      leftTitles: AxisTitles()),

                  // グラフの外枠線
                  borderData: FlBorderData(
                    show: true, // 外枠線の有無
                    border: Border.all(
                      // 外枠線の色
                      color: Color.fromARGB(255, 33, 42, 49),
                    ),
                  ),

                  minY: jwtprovider.getMinWeight() * 0.9,
                  maxY: jwtprovider.getMaxWeight() * 1.1,

                  // チャート線の設定
                  lineBarsData: [
                    LineChartBarData(
                      spots: convertSpotdata(jwtprovider),
                      isCurved: false, // チャート線を曲線にするか折れ線にするか
                      barWidth: 1.0, // チャート線幅
                      isStrokeCapRound: false, // チャート線の開始と終了がQubicかRoundか（？）
                      dotData: FlDotData(
                        show: true, // 座標のドット表示の有無
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          // ドットの詳細設定
                          radius: 2.0,
                          color: Colors.blue,
                          strokeWidth: 2.0,
                          strokeColor: Colors.blue,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        // チャート線下部に色を付ける場合の設定
                        show: false, // チャート線下部の表示の有無
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(5),
                itemCount: jwtprovider.weightList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Container(color: Colors.white, height: 10);
                },
                itemBuilder: (context, index) => ChartItemButton(
                    index: index, weight: jwtprovider.weightList[index]),
              ),
            ),
          ],
        );
      }
    });
  }

  List<FlSpot> convertSpotdata(JwtProvider jwt) {
    jwt.weightList.sort(((a, b) => a.saved_at.compareTo(b.saved_at)));
    DateTime base = jwt.weightList[0].saved_at;
    return List.generate(jwt.weightList.length, (index) {
      final Duration difference =
          jwt.weightList[index].saved_at.difference(base);
      return FlSpot(difference.inDays.toDouble(), jwt.weightList[index].weight);
    });
  }
}

import 'package:flutter/material.dart';
import './listbutton.dart';
import './jwtprovider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import './models.dart';
import './chartitem.dart';

class StockChart extends StatefulWidget {
  const StockChart({Key? key}) : super(key: key);
  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JwtProvider>(builder: (context, jwtprovider, child) {
      double tmpcolor =
          Theme.of(context).colorScheme.inversePrimary.computeLuminance();
      Color color = tmpcolor > 0.5 ? Colors.black : Colors.white;
      if (jwtprovider.weightList.isEmpty) {
        return const Text('no data');
      } else {
        return Column(
          children: <Widget>[
            // Container(
            //   height: 60,
            //   width: double.infinity,
            //   color: Colors.green[100],
            //   padding: const EdgeInsets.all(20),
            //   child: Text(
            //     '年間配当 ${jwtprovider.get_sumtotal().toString()}円',
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //       color: color,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            Container(
              color: Colors.white,
              height: 300,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  // タッチ操作時の設定
                  lineTouchData: LineTouchData(
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
                    horizontalInterval: 1.0, // 背景グリッドの横線間隔
                    verticalInterval: 1.0, // 背景グリッドの縦線間隔
                    getDrawingHorizontalLine: (value) {
                      // 背景グリッドの横線設定
                      return FlLine(
                        color: Color(0xff37434d), // 背景横線の色
                        strokeWidth: 1.0, // 背景横線の太さ
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      // 背景グリッドの縦線設定
                      return FlLine(
                        color: Color(0xff37434d), // 背景縦線の色
                        strokeWidth: 1.0, // 背景縦線の太さ
                      );
                    },
                  ),

                  // グラフのタイトル設定
                  titlesData: FlTitlesData(
                      show: true, // タイトルの有無
                      bottomTitles: AxisTitles(
                        // 下側に表示するタイトル設定
                        axisNameWidget: Text(
                          "【曜日】", // タイトル名
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
                      rightTitles: AxisTitles(), // 上記と同じため割愛
                      topTitles: AxisTitles(),
                      leftTitles: AxisTitles()),

                  // グラフの外枠線
                  borderData: FlBorderData(
                    show: true, // 外枠線の有無
                    border: Border.all(
                      // 外枠線の色
                      color: Color(0xff37434d),
                    ),
                  ),

                  minY: 40,
                  maxY: 60,
                  // チャート線の設定
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        // 表示する座標のリスト
                        FlSpot(0.0, 3.0),
                        FlSpot(1.0, 2.0),
                        FlSpot(2.0, 5.0),
                        FlSpot(3.0, 3.0),
                        FlSpot(4.0, 4.0),
                        FlSpot(5.0, 3.0),
                        FlSpot(6.0, 4.0),
                      ],
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
            // Expanded(
            //   child: ListView.separated(
            //     padding: const EdgeInsets.all(5),
            //     itemCount: portfolios.portfolios.length,
            //     separatorBuilder: (BuildContext context, int index) {
            //       return Container(color: Colors.white, height: 10);
            //     },
            //     itemBuilder: (context, index) => ChartItemButton(
            //         index: index, port: portfolios.portfolios[index]),
            //   ),
            // ),
          ],
        );
      }
    });
  }

  // List<PieChartSectionData> showingSections(PortfolioNotifier portfolios) {
  //   return List.generate(portfolios.portfolios.length, (index) {
  //     final isTouched = false;
  //     final total = portfolios.get_sumtotal().toInt();
  //     final fontSize = isTouched ? 25.0 : 16.0;
  //     final radius = isTouched ? 60.0 : 100.0;
  //     const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

  //     Portfolio port = portfolios.portfolios[index];
  //     int ratio = 0;
  //     if (total != 0) {
  //       ratio = ((port.divide * port.num) / total * 100).toInt();
  //     }
  //     return PieChartSectionData(
  //       color: colorlist[index % colorlist.length],
  //       value: ratio.toDouble(),
  //       title: '${ratio.toString()}%',
  //       radius: radius,
  //       titlePositionPercentageOffset: 0.7,
  //       titleStyle: TextStyle(
  //         fontSize: fontSize,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black,
  //         shadows: shadows,
  //       ),
  //     );
  //   });
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:realtime_line_chart/screens/chart/bloc/opinion_price_bloc.dart';
import 'package:realtime_line_chart/screens/widgets/chart_info_widget.dart';


class ChartScreen extends StatelessWidget {
  ChartScreen({super.key});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Opinion Price Chart',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF211E34),
      ),
      backgroundColor: const Color(0xFF211E34),
      body: BlocProvider(
        create: (context) => OpinionPriceBloc()..add(StartUpdatingPrices()),
        child: Center(
          child: BlocBuilder<OpinionPriceBloc, OpinionPriceState>(
            builder: (context, state) {
              if (state is OpinionPriceUpdated) {
                return Column(
                  children: [
                    Expanded(
                      child: RawScrollbar(
                        trackColor: const Color(0xFF211E34),
                        thumbColor: Colors.white38,
                        radius: const Radius.circular(10),
                        thickness: 10,
                        trackVisibility: true,
                        thumbVisibility: true,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        interactive: true,
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 10000,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: LineChart(
                              LineChartData(
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(),
                                  rightTitles: const AxisTitles(),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          "${value.toString()}₹",
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    axisNameSize: 30,
                                    axisNameWidget: const Text(
                                      'Time',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      interval: 60000 *
                                          (state.seconds.toDouble() / 60),
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        if (value ==
                                            state.prices.first.time
                                                .millisecondsSinceEpoch
                                                .toDouble()) {
                                          return Text('');
                                        }
                                        final DateTime time =
                                            DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt(),
                                        );
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 8.0, right: 8),
                                          child: Text(
                                              "${time.hour}:${time.minute.toString().padLeft(2, '0')}"),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                backgroundColor: const Color(0xFF28253B),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    preventCurveOverShooting: true,
                                    spots: state.prices.map((e) {
                                      return FlSpot(
                                        e.time.millisecondsSinceEpoch
                                            .toDouble(),
                                        e.price,
                                      );
                                    }).toList(),
                                    isCurved: true,
                                    curveSmoothness: 0.5,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF50E4FF),
                                        Color(0xFF2196F3)
                                      ],
                                    ),
                                    barWidth: 5,
                                    isStrokeCapRound: true,
                                    dotData: const FlDotData(
                                      show: true,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF50E4FF),
                                          const Color(0xFF2196F3)
                                        ]
                                            .map((color) =>
                                                color.withOpacity(0.3))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  LineChartBarData(
                                    dotData: const FlDotData(show: false),
                                    barWidth: 4,
                                    color: const Color(0xFFFF3AF2),
                                    spots: state.averagePrices.map((e) {
                                      return FlSpot(
                                        e.time.millisecondsSinceEpoch
                                            .toDouble(),
                                        double.parse(
                                            e.price.toStringAsFixed(2)),
                                      );
                                    }).toList(),
                                  ),
                                ],
                                minX: state.prices.isNotEmpty
                                    ? state.prices.first.time
                                        .millisecondsSinceEpoch
                                        .toDouble()
                                    : 0,
                                maxX: state.prices.isNotEmpty
                                    ? state.prices.last.time
                                        .add(Duration(minutes: state.seconds))
                                        .millisecondsSinceEpoch
                                        .toDouble()
                                    : 0,
                                minY: 0,
                                maxY: 200,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const ChartInfoWidget(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Toggle Time Frame',
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    dropdownColor: const Color(0xFF211E34),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    value: state.seconds,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 60,
                                        child: Text('1 Minute'),
                                      ),
                                      DropdownMenuItem(
                                        value: 300,
                                        child: Text('5 Minutes'),
                                      ),
                                      DropdownMenuItem(
                                        value: 3600,
                                        child: Text('1 Hour'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      context
                                          .read<OpinionPriceBloc>()
                                          .add(ToggleTimeFrame(value as int));
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
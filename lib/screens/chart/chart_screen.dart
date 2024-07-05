import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:realtime_line_chart/screens/chart/bloc/opinion_price_bloc.dart';


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
                print('TOTAL PRICES: ${state.prices.length}');
                // final currentTime = DateTime.now();
                // final threeHoursFromNow = currentTime.add(Duration(hours: 3));

                // // Filter data to include only relevant time window
                // final filteredPrices = state.prices.where((pricePoint) {
                //   return pricePoint.time.isAfter(
                //           currentTime.subtract(Duration(minutes: 1))) &&
                //       pricePstate.averageoint.time.isBefore(threeHoursFromNow);
                // }).toList();

                return Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
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
                                horizontal: 16, vertical: 20),
                            child: LineChart(
                              LineChartData(
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(),
                                  rightTitles: const AxisTitles(),
                                  leftTitles: AxisTitles(
                                    // axisNameSize: 40,
                                    // axisNameWidget: const Text(
                                    //   'Price (₹)',
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 20,
                                    //   ),
                                    // ),
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

                                            if(value == state.prices.first.time.millisecondsSinceEpoch.toDouble()){
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
                                        e.price,
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
                                    padding: EdgeInsets.all(10),
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


// class ChartScreen extends StatelessWidget {
//   const ChartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Opinion Price Chart')),
//       body: BlocProvider(
//         create: (context) => OpinionPriceBloc()..add(StartUpdatingPrices()),
//         child: BlocBuilder<OpinionPriceBloc, OpinionPriceState>(
//           builder: (context, state) {
//             if (state is OpinionPriceUpdated) {
//               print('PRICES: ${state.prices.first.price}');
//               return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   width: 10000,
//                   child: LineChart(
//                     LineChartData(
//                       gridData: const FlGridData(
//                         show: true,
//                       ),
//                       clipData: const FlClipData.all(
//                       ),
//                       titlesData: FlTitlesData(
//                         show: true,
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (double value, TitleMeta meta) {
//                                 // print('VALUE: $value');
//                                 const style = TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 );
//                                 Widget text;
                  
//                                 text =
//                                     Text('${value.toInt()}', style: style);
//                                 return SideTitleWidget(
//                                   axisSide: meta.axisSide,
//                                   child: text,
//                                 );
//                               }),
//                         ),
//                         rightTitles:const AxisTitles(axisNameSize: 0,axisNameWidget: const SizedBox.shrink(),),
//                         topTitles:const  AxisTitles(axisNameSize: 0,axisNameWidget: const SizedBox.shrink(),),
//                       ),
//                       borderData: FlBorderData(show: true),
//                       lineBarsData: [
//                         LineChartBarData(
//                           gradient: LinearGradient(
//                             colors: [
//                               ColorTween(
//                                       begin: const Color(0xFF50E4FF),
//                                       end: const Color(0xFF2196F3))
//                                   .lerp(0.2)!,
//                               ColorTween(
//                                       begin: const Color(0xFF50E4FF),
//                                       end: const Color(0xFF2196F3))
//                                   .lerp(0.2)!,
//                             ],
//                           ),
//                           spots: state.prices
//                               .map((e) => FlSpot(
//                                   e.time.millisecondsSinceEpoch.toDouble(),
//                                   e.price))
//                               .toList(),
//                           isCurved: true,
//                           barWidth: 2,
//                           // colors: [Colors.blue],
//                           // color: Colors.blue,
//                           dotData: const FlDotData(show: true),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             gradient: LinearGradient(
//                               colors: [
//                                 ColorTween(
//                                         begin: const Color(0xFF50E4FF),
//                                         end: const Color(0xFF2196F3))
//                                     .lerp(0.2)!
//                                     .withOpacity(0.1),
//                                 ColorTween(
//                                         begin: const Color(0xFF50E4FF),
//                                         end: const Color(0xFF2196F3))
//                                     .lerp(0.2)!
//                                     .withOpacity(0.1),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                       minX: state.prices.isNotEmpty
//                           ? state.prices.first.time.millisecondsSinceEpoch.toDouble()
//                           : 0,
//                       maxX: state.prices.isNotEmpty
//                           ? state.prices.last.time.millisecondsSinceEpoch.toDouble()
//                           : 0,
//                       minY: 0,
//                       maxY: 200,
//                     ),
//                     curve: Curves.bounceInOut,
//                   ),
//                 ),
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }

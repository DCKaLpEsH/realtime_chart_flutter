

import 'package:flutter/material.dart';
import 'package:realtime_line_chart/screens/widgets/line_info_widget.dart';

class ChartInfoWidget extends StatelessWidget {
  const ChartInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LineInfoWidget(
            title: 'Average Price',
            color: Color(0xFFFF3AF2),
          ),
          SizedBox(
            height: 20,
          ),
          LineInfoWidget(
            color: Color(0xFF2196F3),
            title: 'Price every 5 sec',
          )
        ],
      ),
    );
  }
}

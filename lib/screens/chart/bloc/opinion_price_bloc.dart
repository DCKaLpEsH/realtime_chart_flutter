import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_line_chart/models/price_point.dart';

part 'opinion_price_event.dart';
part 'opinion_price_state.dart';

class OpinionPriceBloc extends Bloc<OpinionPriceEvent, OpinionPriceState> {
  OpinionPriceBloc() : super(OpinionPriceInitial()) {
    on<StartUpdatingPrices>((event, emit) async {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        final newPrice = _generateRandomPrice();
        final currentTime = DateTime.now();
        add(UpdatePrice(currentTime, newPrice));
      });
    });
    on<UpdatePrice>((event, emit) {
      final price = event.price;

      if (state is OpinionPriceUpdated) {
        final prevState = state as OpinionPriceUpdated;
        final currPrice = prevState.prevTotal + price;
        final currAvg = currPrice / prevState.prices.length;
        final updatedPrices = List<PricePoint>.from(prevState.prices)
          ..add(PricePoint(event.time, event.price));
        final updatedAvg = List<PricePoint>.from(prevState.averagePrices)
          ..add(PricePoint(event.time,currAvg));
        emit(OpinionPriceUpdated(
          updatedPrices,
          prevState.seconds,
          currPrice,
          updatedAvg,
        ));
      } else {
        final updatedPrices = [PricePoint(event.time, event.price)];
        final avgPrice = event.price;
        emit(
          OpinionPriceUpdated(
            updatedPrices,
            60,
            0.0,
            <PricePoint>[
              PricePoint(event.time, avgPrice),
            ],
          ),
        );
      }
    });
    on<ToggleTimeFrame>((event, emit) {
      if (state is OpinionPriceUpdated) {
        final prevState = state as OpinionPriceUpdated;
        emit(OpinionPriceUpdated(prevState.prices, event.seconds,
            prevState.prevTotal, prevState.averagePrices));
      }
    });
  }

  double _generateRandomPrice() {
    return 100 + Random().nextInt(80).toDouble();
  }
}

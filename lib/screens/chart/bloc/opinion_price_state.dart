part of 'opinion_price_bloc.dart';

sealed class OpinionPriceState extends Equatable {
  const OpinionPriceState();

  @override
  List<Object> get props => [];
}

class OpinionPriceInitial extends OpinionPriceState {}

class OpinionPriceUpdated extends OpinionPriceState {
  final List<PricePoint> prices;
  final List<PricePoint> averagePrices;
  final int seconds;
  final double prevTotal;
  // final double average;
  const OpinionPriceUpdated(this.prices, this.seconds, this.prevTotal, this.averagePrices);

  OpinionPriceUpdated copyWith({
    List<PricePoint>? prices,
    int? seconds,
    double? prevTotal,
    List<PricePoint>? averagePrices,
  }) {
    return OpinionPriceUpdated(
      prices ?? this.prices,
      seconds ?? this.seconds,
      prevTotal ?? this.prevTotal,
      averagePrices ?? this.averagePrices,
    );
  }

  @override
  List<Object> get props => [prices, seconds, prevTotal, averagePrices];
}

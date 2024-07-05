part of 'opinion_price_bloc.dart';

sealed class OpinionPriceEvent extends Equatable {
  const OpinionPriceEvent();

  @override
  List<Object> get props => [];
}

class StartUpdatingPrices extends OpinionPriceEvent {
  @override
  List<Object> get props => [];
}

class UpdatePrice extends OpinionPriceEvent {
  final DateTime time;
  final double price;

  const UpdatePrice(this.time, this.price);

  @override
  List<Object> get props => [time, price];
}

class ToggleTimeFrame extends OpinionPriceEvent {
  final int seconds;

  const ToggleTimeFrame(this.seconds);
  @override
  List<Object> get props => [];
}

part of 'product_bloc.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {}

final class ProductError extends ProductState {
  final String message;

  ProductError(
    this.message,
  );
}

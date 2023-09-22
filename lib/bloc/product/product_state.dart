part of 'product_bloc.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}
final class ProductLoadingAdd extends ProductState {}
final class ProductLoadingUpdate extends ProductState {}
final class ProductLoadingDelete extends ProductState {}
final class ProductLoadingExport extends ProductState {}
final class ProductLoadingDetail extends ProductState {}

final class ProductLoadedAdd extends ProductState {}
final class ProductLoadedUpdate extends ProductState {}
final class ProductLoadedDelete extends ProductState {}
final class ProductLoadedExport extends ProductState {}
final class ProductLoadedDetail extends ProductState {}

final class ProductError extends ProductState {
  final String message;

  ProductError(
    this.message,
  );
}

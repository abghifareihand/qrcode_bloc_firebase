part of 'product_bloc.dart';

abstract class ProductEvent {}

class AddProductEvent extends ProductEvent {
  final String code;
  final String name;
  final int qty;
  AddProductEvent({
    required this.code,
    required this.name,
    required this.qty,
  });
}

class UpdateProductEvent extends ProductEvent {
  final String productId;
  final String name;
  final int qty;
  UpdateProductEvent({
    required this.productId,
    required this.name,
    required this.qty,
  });
}

class DeleteProductEvent extends ProductEvent {
  final String id;
  DeleteProductEvent({
    required this.id,
  });
}

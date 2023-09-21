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

class EditProductEvent extends ProductEvent {}

class DeleteProductEvent extends ProductEvent {}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    on<AddProductEvent>((event, emit) async {
      try {
        emit(ProductLoading());
        // menambahkan product ke firebase
        final result = await firestore.collection('products').add({
          'name': event.name,
          'code': event.code,
          'qty': event.qty,
        });
        await firestore.collection('products').doc(result.id).update({
          'productId': result.id,
        });
        emit(ProductLoaded());
      } on FirebaseException catch (e) {
        // error firebase auth
        emit(ProductError(e.message ?? 'Ga bisa nambah product'));
      } catch (e) {
        // error general
        emit(ProductError('Ga bisa nambah product'));
      }
    });
    on<EditProductEvent>((event, emit) {
      // mengedit product ke firebase
    });
    on<DeleteProductEvent>((event, emit) {
      // menghapus product ke firebase
    });
  }
}

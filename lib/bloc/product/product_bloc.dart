import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcode_bloc_firebase/models/product_model.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<ProductModel>> streamProducts() async* {
    yield* firestore
        .collection('products')
        .withConverter<ProductModel>(
          fromFirestore: (snapshot, _) =>
              ProductModel.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductInitial()) {
    on<AddProductEvent>((event, emit) async {
      try {
        emit(ProductLoadingAdd());
        // menambahkan product ke firebase
        final result = await firestore.collection('products').add({
          'name': event.name,
          'code': event.code,
          'qty': event.qty,
        });
        await firestore.collection('products').doc(result.id).update({
          'productId': result.id,
        });
        emit(ProductLoadedAdd());
      } on FirebaseException catch (e) {
        // error firebase auth
        emit(ProductError(e.message ?? 'Ga bisa nambah product'));
      } catch (e) {
        // error general
        emit(ProductError('Ga bisa nambah product'));
      }
    });
    on<UpdateProductEvent>((event, emit) async {
      try {
        emit(ProductLoadingUpdate());
        // mengupdate product ke firebase
        await firestore.collection('products').doc(event.productId).update({
          'name': event.name,
          'qty': event.qty,
        });
        emit(ProductLoadedUpdate());
      } on FirebaseException catch (e) {
        // error firebase auth
        emit(ProductError(e.message ?? 'Ga bisa nambah product'));
      } catch (e) {
        // error general
        emit(ProductError('Ga bisa nambah product'));
      }
    });
    on<DeleteProductEvent>((event, emit) async {
      try {
        emit(ProductLoadingDelete());
        // menghapus product ke firebase
        await firestore.collection('products').doc(event.id).delete();
        emit(ProductLoadedDelete());
      } on FirebaseException catch (e) {
        // error firebase auth
        emit(ProductError(e.message ?? 'Ga bisa menghapus product'));
      } catch (e) {
        // error general
        emit(ProductError('Ga bisa menghapus product'));
      }
    });
  }
}

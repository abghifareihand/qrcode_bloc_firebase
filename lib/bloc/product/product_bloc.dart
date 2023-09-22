import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:qrcode_bloc_firebase/models/product_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
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
    on<ExportProductEvent>((event, emit) async {
      try {
        emit(ProductLoadingExport());
        // 1. Ambil semua data product dari firebase
        QuerySnapshot<ProductModel> querySnapshot = await firestore
            .collection('products')
            .withConverter<ProductModel>(
              fromFirestore: (snapshot, _) =>
                  ProductModel.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        List<ProductModel> allProducts = [];

        for (var element in querySnapshot.docs) {
          ProductModel product = element.data();
          allProducts.add(product);
        }
        // allproduct udah ada isinya sesuai di database

        // 2. Create pdfnya
        final pdf = pw.Document();

        // masukin data products ke pdf
        // var data = await rootBundle.load("assets/fonts/OpenSansRegular.ttf");
        // var myFont = Font.ttf(data);
        // var myStyle = TextStyle(font: myFont);

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              List<pw.TableRow> allData = List.generate(
                allProducts.length,
                (index) {
                  ProductModel product = allProducts[index];
                  return pw.TableRow(
                    children: [
                      // No
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "${index + 1}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // Kode Barang
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          product.code!,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // Nama Barang
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          product.name!,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // Qty
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "${product.qty}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // QR Code
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.BarcodeWidget(
                          color: PdfColor.fromHex("#000000"),
                          barcode: pw.Barcode.qrCode(),
                          data: product.code!,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  );
                },
              );

              return [
                pw.Center(
                  child: pw.Text(
                    "CATALOG PRODUCTS",
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColor.fromHex("#000000"),
                    width: 2,
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        // No
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "No",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // Kode Barang
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Product Code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // Nama Barang
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Product Name",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // Qty
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Quantity",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // QR Code
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "QR Code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...allData,
                  ],
                ),
              ];
            },
          ),
        );

        // 3. Open pdfnya
        Uint8List bytes = await pdf.save();

        final dir = await getApplicationCacheDirectory();
        File file = File('${dir.path}/myproducts.pdf');

        // masukin data bytes ke file pdf
        await file.writeAsBytes(bytes);

        OpenFile.open(file.path);
        print('Tes pdf : ${file.path}');

        emit(ProductLoadedExport());
      } on FirebaseException catch (e) {
        // error firebase auth
        emit(ProductError(e.message ?? 'Ga bisa mengexport pdf product'));
      } catch (e) {
        // error general
        emit(ProductError('Ga bisa mengexport pdf product'));
      }
    });
    on<DetailProductEvent>((event, emit) async {
      try {
        emit(ProductLoadingDetail());
        // menghapus product ke firebase
        final result = await firestore.collection('products').doc(event.id).get();
        ProductModel.fromJson(result.data()!);
        emit(ProductLoadedDetail());
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

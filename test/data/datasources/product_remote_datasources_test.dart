import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  late ProductRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = ProductRemoteDataSourceImpl(client: http.Client());
  });

  group("Get Product", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.getProduct("63e91cbfcb3199d254550b73");
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Search Product", () {
    test('asdfas fasdf sd', () async {
      try {
        final result = await dataSource.searchProduct();
        print(result);
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Add product", () {
    test('add product', () async {
      try {
        final result = await dataSource.addProduct(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2Nzc2MDI2NzV9.mpgkDUFd0aGx_onTCM_J6C7HW1wUrpfyW5dIuImQ9lk",
          name: "Tolak Angin",
          images: [
            "https://images.tokopedia.net/img/cache/900/product-1/2021/4/7/10626799/10626799_620994cb-e761-46bf-8ddc-dcff5d26b7e2.png",
            "https://images.tokopedia.net/img/cache/900/product-1/2021/4/7/10626799/10626799_a0ad4c50-bfa5-4ab6-a8cf-2681fbcddd31.png",
            "https://images.tokopedia.net/img/cache/900/product-1/2021/4/7/10626799/10626799_5e15f91a-eef3-454e-93e4-6b7cc4ceae70.png",
            "https://images.tokopedia.net/img/cache/900/product-1/2021/4/7/10626799/10626799_6e4803ed-337b-4532-9874-4ef7aa927077.png",
            "https://images.tokopedia.net/img/cache/900/product-1/2021/4/7/10626799/10626799_4789c492-3328-4b49-99dc-1cb64bb1ce40.png"
          ],
          price: 39750,
          stock: 100,
          description: '''
KANDUNGAN/KOMPOSISI
Amoni Fructus (kapulaga), Foeniculli Fructus (adas), Isorae Fructus (kayu ules), Myristicae Semen (pala), Burmanni Cortex (kayu manis), Centellae Herba (pegagan), Caryophylli Folium (cengkeh), Parkiae Semen (kedawung), Oryza sativa (beras), Menthae arvensitis Herba (poko), Usneae thallus (kayu angin), Zingiberis Rhizoma(jahe), ekstrak Panax Radix, 70% Mel Depuratum (Madu).

DOSIS
Untuk daya tahan tubuh: minum 1 sachet, 2 kali per hari. Selama 7 hari atau lebih. Untuk masuk angin/sakit perut dan diare: minum 1 sachet, 3 sampai 4 kali per hari. Sebelum melakukan perjalanan minum 1 sachet, atau 1-3 sachet pada waktu mabuk perjalanan. Saat kecapaian dan kurang tidur, minum 1 sachet. Untuk mabuk atau saat melakukan perjalanan: minum 1 sachet, 1 kali per hari.

CARA PEMAKAIAN
Setelah makan. Obat dapat langsung diminum atau dapat dicampur dengan air.

INDIKASI/ KEGUNAAN
Herbal untuk mengatasi masuk angin, seperti:pusing, meriang, kembung, sakit perut, tengorokan kering, mual dan muntah, serta meningkatkan daya tahan tubuh. Tolak angin cair juga dapat diminum saat perjalanan jauh, kecapaian dan kurang tidur.

MANUFAKTUR
Sido Muncul

KEMASAN
Box, 12 Sachet @ 15 ml

PERHATIAN KHUSUS
Obat ini tidak direkomendasikan untuk wanita hamil.

GOLONGAN
Herbal            
            ''',
          categoryId: "63f85eacaf9b5c7b110dcd59",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
}

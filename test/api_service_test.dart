import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:restoranapp/api/apiservice.dart';
import 'package:restoranapp/ui/model/resto_model.dart';
import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('test Restaurant', () {
    test("return data list restaurant", () async {
      final client = MockClient();

      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async => http.Response(
              '{"error": false, "message": "success", "count": 20, "restaurants" : []}',
              200));

      expect(await ApiService().listResto(client), isA<RestoModel>());
    });
  });
}

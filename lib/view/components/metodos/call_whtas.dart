import 'package:url_launcher/url_launcher.dart';

class Calls{
  //funcion asincrona para enviar whatssap
  Future<void> sendWhats({
    required String phone,
    required String text
  }) async {
    if (!await launchUrl(Uri.parse("https://wa.me/$phone?text=$text"))) {
      throw Exception('No puede encontrar numero $phone');
    }
  }

  //funcion asincrona para llamadas
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}

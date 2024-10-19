import 'package:flutter/material.dart';
import '../../../app/models/http_response.dart';
import 'form_button.dart';

class PagesResponses extends StatelessWidget {
  HttpResponsse httpResponsse;

  PagesResponses({super.key, required this.httpResponsse});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: CircleAvatar(
                      child: Icon(Icons.warning_amber, size: 30),
                    ),
                  ),
                  FormButtom(
                      ejecutar: () {},
                      title: "Reintentar",
                      icon: const Icon(Icons.refresh))
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    httpResponsse.isRequest
                        ? "Servidor Conectado"
                        : "Servidor NO Conectado",
                  ),
                  Text(httpResponsse.isSuccess
                      ? "Envio al servidor completo"
                      : "Envio al servidor incompleto"),
                  Text(httpResponsse.messageError
                      ? "Envio con mensajes de error"
                      : "Envio sin mensajes de error"),
                  Text(httpResponsse.message)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

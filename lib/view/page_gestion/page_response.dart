import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/models/http_response.dart';

class PageResponse extends StatelessWidget {
  bool isLoading;
  HttpResponsse httpResponsse;
  PageResponse(
      {super.key, this.isLoading = false, required this.httpResponsse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            httpResponsse.isRequest
                ? const SizedBox(height: 1)
                : Text(
                    "Nuestros servidores estan en mantenimiento intente mas tarde porfavor".toUpperCase(),
              maxLines: 2,
              style: TextStyle(
                  color: httpResponsse.isSuccess ? Colors.green : Colors.red,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 15),
            Text("Message: '${httpResponsse.message}'", style: TextStyle(
              fontWeight: FontWeight.w300,
              color: httpResponsse.isSuccess ? Colors.green : Colors.red,
            ),),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}

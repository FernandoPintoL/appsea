import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/models/user_model.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/widget/dialog.dart';
import '../../components/widget/image_component.dart';
import '../../config/pallet.dart';
import '../../page_gestion/card_list.dart';
import '../update_user/update_user.dart';

class UsersList extends StatelessWidget {
  List<Usuario> listado;

  UsersList({super.key, required this.listado});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(defaultPadding),
        itemCount: listado.length,
        itemBuilder: (BuildContext context, int index) {
          return CardList(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("COD: " + listado[index].id.toString()),
                Text(listado[index].name)
              ],
            ),
            subtitle: Text(listado[index].email.toString()),
            leading: ImageComponent(
              size: 80,
              imageUrl: listado[index].profilePhotoUrl.toString(),
              errorWidget:
                  const CircleAvatar(child: Icon(Icons.warning_amber_sharp)),
              function: () {},
            ),
            isRequiredTrailing: true,
            isSelectTrailing: false,
            functionTrailing: () {
              DialogMessage.dialog(
                  context,
                  DialogType.question,
                  'Eliminar Categoria',
                  'Estas seguro de eliminar ${listado[index].name.toString().toUpperCase()}?',
                  () async {
                context
                    .read<UserProvider>()
                    .eliminando(context, listado[index]);
              });
            },
            function: () {
              context.read<UserProvider>().openUserUpdate(listado[index]);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateUser()),
              );
            },
          );
        });
  }
}

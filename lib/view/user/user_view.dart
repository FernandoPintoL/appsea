import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/providers/user_provider.dart';
import '../page_gestion/page_gestion.dart';
import 'list_user/users_list.dart';
import 'register_user/register_user.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late FocusNode focusQuery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusQuery = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('GESTION DE USUARIO'),
      ),
      body: SafeArea(
        child: PageGestion(
          label: "Buscador de Usuarios",
          queryController: context.watch<UserProvider>().queryController,
          focusNode: focusQuery,
          httpResponsse: context.watch<UserProvider>().httpResponsse,
          isLoading: context.watch<UserProvider>().isLoading,
          textLoading: "Cargando página...",
          functionBuscar: () {
            context.read<UserProvider>().consultando(context);
          },
          registrarNuevo: () {
            context.read<UserProvider>().openFormularioRegister();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterUser()),
            );
          },
          refrescarPagina: () {
            context.read<UserProvider>().cargandoLista("");
          },
          isListEmpty: context.watch<UserProvider>().lista.isEmpty,
          listado: context.watch<UserProvider>().lista,
          listadoWidget:
              UsersList(listado: context.watch<UserProvider>().lista),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserProvider>().openFormularioRegister();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterUser()),
          );
        },
        tooltip: "Registra un nuevo usuario",
        child: const Icon(CupertinoIcons.add_circled),
      ),
    );
  }
}

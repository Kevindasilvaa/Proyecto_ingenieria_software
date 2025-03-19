import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/cuenta.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/AddAccountButton.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/screens/addAccount.dart';

class AccountsPage extends StatefulWidget {
  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<Cuenta> _accounts = [];
  StreamSubscription? _accountSubscription;
  final CuentaController _cuentaController = CuentaController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCuentas();
  }

  @override
  void dispose() {
    _accountSubscription?.cancel();
    super.dispose();
  }

  // Este método asegura que el usuario esté disponible antes de cargar las cuentas
  Future<void> _cargarCuentas() async {
    final userController = Provider.of<UserController>(context, listen: false);

    // Si el usuario no está cargado, esperamos hasta que se cargue
    if (userController.usuario == null) {
      setState(() {
        _isLoading = true; // Indicamos que estamos esperando el usuario
      });
      // Esperamos un poco para que el estado del usuario pueda ser cargado.
      await Future.delayed(Duration(seconds: 2));
    }

    if (userController.usuario != null) {
      try {
        _accountSubscription?.cancel();
        _accounts = [];
        _accountSubscription = _cuentaController
            .cargarCuentas(userController.usuario!.email)
            .asStream()
            .listen((_) {
          setState(() {
            _accounts = _cuentaController.cuentas;
            _isLoading = false; // Terminamos de cargar las cuentas
          });
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cargar las cuentas.'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      setState(() {
        _isLoading = false; // Terminamos de esperar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final userEmail = userController.usuario?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Cuentas'),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator()) // Indicador de carga
                : userEmail != null
                    ? _buildAccountList(_accounts)
                    : Center(child: Text('Inicia sesión para ver tus cuentas')),
          ),
          Container(
            height: 100.0,
            child: NavBar(
              onPlusPressed: () async {
                if (userEmail != null) {
                  // Navegar a la página para agregar cuenta
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAccountPage()),
                  );
                  // Recargar las cuentas después de agregar una nueva
                  await _cargarCuentas();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Inicia sesión para agregar cuentas'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              currentPage: '/accounts',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountList(List<Cuenta> accounts) {
    if (accounts.isEmpty) {
      return Center(child: Text('No hay cuentas registradas.'));
    }
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final cuenta = accounts[index];
        return _buildAccountContainer(cuenta);
      },
    );
  }

  Widget _buildAccountContainer(Cuenta cuenta) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Mostrar el ícono de la cuenta (o un ícono predeterminado)
              Icon(
                cuenta.icono ??
                    Icons
                        .account_balance, // Ícono predeterminado si no se asigna ninguno
                color: Colors.blueAccent,
                size: 40,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cuenta.nombre,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('Saldo: ${cuenta.saldo} ${cuenta.tipoMoneda}'),
                ],
              ),
            ],
          ),
          // Asegúrate de incluir el IconButton dentro del Row
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmarEliminacion(cuenta),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminacion(Cuenta cuenta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content:
              Text("¿Seguro que desea eliminar la cuenta '${cuenta.nombre}'?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () {
                _cuentaController
                    .eliminarCuenta(cuenta.idCuenta, cuenta.userEmail)
                    .then((_) {
                  Navigator.of(context).pop();
                  _cargarCuentas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cuenta eliminada exitosamente')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la cuenta')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}

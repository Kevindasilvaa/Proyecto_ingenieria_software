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

  void _showAddAccountDialog(BuildContext context, CuentaController cuentaController, String userEmail) {
  TextEditingController nameController = TextEditingController();
  TextEditingController saldoController = TextEditingController();
  String selectedTipo = 'Ahorro';
  String selectedMoneda = 'USD';
  IconData? selectedIcon = Icons.account_balance;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2E4A5A), // Fondo azul oscuro
            title: const Text(
              'Agregar Cuenta',
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // Ancho ajustado
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white, // Fondo blanco para los inputs
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.title, color: Colors.black),
                          labelText: 'Nombre de la cuenta',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tipo de cuenta
                    Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: DropdownButtonFormField<String>(
                        value: selectedTipo,
                        onChanged: (value) => setState(() {
                          selectedTipo = value!;
                        }),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.category, color: Colors.black),
                          labelText: 'Tipo de cuenta',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        items: ['Ahorro', 'Corriente', 'Inversión']
                            .map((tipo) => DropdownMenuItem(
                                  value: tipo,
                                  child: Text(tipo),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tipo de moneda
                    Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: DropdownButtonFormField<String>(
                        value: selectedMoneda,
                        onChanged: (value) => setState(() {
                          selectedMoneda = value!;
                        }),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.monetization_on, color: Colors.black),
                          labelText: 'Tipo de moneda',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        items: ['BS', 'USD', 'EUR', 'MXN']
                            .map((moneda) => DropdownMenuItem(
                                  value: moneda,
                                  child: Text(moneda),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Saldo inicial
                    Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: TextFormField(
                        controller: saldoController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.money, color: Colors.black),
                          labelText: 'Saldo inicial',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Selección de ícono
                    Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: DropdownButtonFormField<IconData>(
                        value: selectedIcon,
                        onChanged: (value) => setState(() {
                          selectedIcon = value!;
                        }),
                        decoration: const InputDecoration(
                          //prefixIcon: Icon(Icons.widgets, color: Colors.black),
                          labelText: 'Seleccionar ícono',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: Icons.account_balance,
                            child: Row(
                              children: const [
                                Icon(Icons.account_balance, color: Colors.blue),
                                SizedBox(width: 10),
                                Text('Banco'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: Icons.wallet,
                            child: Row(
                              children: const [
                                Icon(Icons.wallet, color: Colors.green),
                                SizedBox(width: 10),
                                Text('Billetera'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: Icons.credit_card,
                            child: Row(
                              children: const [
                                Icon(Icons.credit_card, color: Colors.purple),
                                SizedBox(width: 10),
                                Text('Tarjeta'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF5DA6A7)), // Fondo verde
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: () {
                  final String nombre = nameController.text.trim();
                  final double? saldo = double.tryParse(saldoController.text.trim());

                  if (nombre.isNotEmpty && saldo != null) {
                    final nuevaCuenta = Cuenta(
                      nombre: nombre,
                      tipo: selectedTipo,
                      saldo: saldo,
                      fechaCreacion: DateTime.now(),
                      userEmail: userEmail,
                      tipoMoneda: selectedMoneda,
                      icono: selectedIcon,
                    );

                    cuentaController.agregarCuenta(nuevaCuenta).then((_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cuenta agregada exitosamente')),
                      );
                      _cargarCuentas();
                    }).catchError((error) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al agregar la cuenta')),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor completa todos los campos')),
                    );
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final userEmail = userController.usuario?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A5A), // Azul del navbar anterior
        elevation: 0,
        title: const Text(
          'Cuentas',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  // Llama al diálogo en lugar de navegar a otra página
                  _showAddAccountDialog(context, _cuentaController, userEmail);
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
        backgroundColor: const Color(0xFF2E4A5A), // Fondo azul similar a la imagen
        title: Text(
          "Confirmar eliminación",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Texto blanco
        ),
        content: Text(
          "¿Seguro que desea eliminar la cuenta '${cuenta.nombre}'?",
          style: const TextStyle(color: Colors.white), // Texto blanco
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent), // Fondo transparente
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFFF44336)), // Fondo rojo similar al botón de eliminación en la imagen
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                ),
              ),
            ),
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Texto blanco
            ),
            onPressed: () {
              _cuentaController
                  .eliminarCuenta(cuenta.idCuenta, cuenta.userEmail)
                  .then((_) {
                Navigator.of(context).pop();
                _cargarCuentas();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cuenta eliminada exitosamente')),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al eliminar la cuenta')),
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
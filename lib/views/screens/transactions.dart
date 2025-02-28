import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:moni/views/widgets/EditTransaction.dart';


class TransactionsPage extends StatefulWidget {
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Transaccion> _transactions = [];
  StreamSubscription? _transactionSubscription;

  final TransaccionesController _transaccionesController =
      TransaccionesController();

  @override
  void initState() {
    super.initState();
    _cargarTransacciones(_selectedDay);
  }

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }

  void _cargarTransacciones(DateTime day) {
    _transactionSubscription?.cancel();
    _transactions = [];

    _transactionSubscription = _transaccionesController
        .obtenerTransaccionesDeUnDia(day)
        .listen((transacciones) {
      setState(() {
        _transactions = transacciones;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Transacciones'),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
            ),
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              calendarFormat: _format,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _cargarTransacciones(_selectedDay);
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _format = format;
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: userController.usuario != null
                  ? _buildTransactionList(_transactions)
                  : Center(child: CircularProgressIndicator()),
            ),
            Container(
              height: 80.0,
              child: NavBar(
                onPlusPressed: () {
                  Navigator.of(context).pushNamed('/addTransactions');
                },
                currentPage: '/transactions',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Transaccion> transactions) {
    if (transactions.isEmpty) {
  
      return Center(child: Text('No hay transacciones para este día.'));
      
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaccion = transactions[index];
        return _buildTransactionContainer(transaccion);
      },
    );
  }

  Widget _buildTransactionContainer(Transaccion transaccion) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(247, 247, 247, 247),
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
        children: [
         
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaccion.nombre,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat('yyyy-MM-dd').format(transaccion.fecha)),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmar eliminación"),
                              content:
                                  Text("¿Seguro que desea eliminar esta transacción?"),
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
                                    _transaccionesController
                                        .eliminarTransaccion(transaccion.id)
                                        .then((_) {
                                      Navigator.of(context).pop();
                                      _cargarTransacciones(_selectedDay);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Transacción eliminada')));
                                    }).catchError((error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error al eliminar')));
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                     IconButton(
                        icon: Icon(Icons.edit, color: const Color.fromARGB(255, 255, 119, 0)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTransaction(transaction: transaccion),
                            ),
                          ).then((result) {
                            if (result != null && result == true) {
                              _cargarTransacciones(_selectedDay);
                            }
                          });
                        },
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${transaccion.monto}',
                      style: TextStyle(
                        color: transaccion.ingreso ? Colors.red : Colors.green,
                      ),
                    ),
                    SizedBox(width: 7)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
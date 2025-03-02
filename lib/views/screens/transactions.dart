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
import 'package:moni/views/widgets/TransactionCard.dart'; // Importa el widget TransactionCard

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
      body: Column(
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
            height: 100.0,
            child: NavBar(
              onPlusPressed: () {
                Navigator.of(context).pushNamed('/addTransactions');
              },
              currentPage: '/transactions',
            ),
          ),
        ],
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
        return TransactionCard(transaccion: transaccion); // Usamos TransactionCard aquí
      },
    );
  }
}

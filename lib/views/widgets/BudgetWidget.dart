// lib/views/widgets/budget_link.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moni/controllers/user_controller.dart';

class BudgetLink extends StatefulWidget {
  // En lugar de "gastoAcumulado", ahora usamos "totalGastos"
  final double totalGastos;
  final double presupuestoMensual;
  final Function(double) onBudgetSet;

  const BudgetLink({
    Key? key,
    required this.totalGastos,
    required this.presupuestoMensual,
    required this.onBudgetSet,
  }) : super(key: key);

  @override
  _BudgetLinkState createState() => _BudgetLinkState();
}

class _BudgetLinkState extends State<BudgetLink> {
  bool _isHovered = false;
  bool _isPressed = false;
  late double _currentBudget;

  @override
  void initState() {
    super.initState();
    // Si el presupuesto establecido es 0, lo inicializamos con el total de gastos
    _currentBudget = widget.presupuestoMensual > 0
        ? widget.presupuestoMensual
        : widget.totalGastos;
  }

  void _onEnter(PointerEvent details) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovered = false;
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTap(BuildContext context) {
  final userController = Provider.of<UserController>(context, listen: false);
  final double currentBudget =
      userController.usuario?.monthlyExpenseBudget ?? _currentBudget;
  final TextEditingController _controller =
      TextEditingController(text: currentBudget.toStringAsFixed(2));

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2E4A5A), // Fondo azul como en el navbar
      title: const Center(
        child: Text(
          'Establece tu presupuesto de gasto mensual',
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white), // Texto blanco
        decoration: const InputDecoration(
          hintText: 'Establezca su presupuesto mensual de gastos',
          hintStyle: TextStyle(color: Colors.white54), // Estilo del hint blanco
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Línea blanca
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Línea blanca al enfocar
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cerrar diálogo
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
        ),
        TextButton(
          onPressed: () async {
            final value = double.tryParse(_controller.text.replaceAll(',', '.'));
            if (value != null && value > 0) {
              // Actualiza el presupuesto en Firebase
              await userController.updateMonthlyExpenseBudget(value);
              setState(() {
                _currentBudget = value;
              });
              widget.onBudgetSet(value);
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Aceptar',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
        ),
      ],
    ),
  );
}

 @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        final double currentBudget =
            userController.usuario?.monthlyExpenseBudget ?? _currentBudget;
        return MouseRegion(
          onEnter: _onEnter,
          onExit: _onExit,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: () => _onTap(context),
            child: Text(
              "${widget.totalGastos.toStringAsFixed(0)}\$ Gastados / ${currentBudget.toStringAsFixed(0)}\$ Total",
              style: TextStyle(
                color: Colors.white, // Cambiado a blanco
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}

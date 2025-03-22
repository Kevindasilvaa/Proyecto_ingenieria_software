import 'package:flutter/material.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:provider/provider.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/models/clases/category.dart';
import 'package:moni/views/widgets/CategoryButton.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryController = Provider.of<CategoryController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A5A), // Azul del navbar anterior
        elevation: 0,
        title: const Text(
          'Categorías',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () =>
                    _showCreateCategoryDialog(context, categoryController),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Crear Categoría',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: StreamBuilder<List<Category>>(
                stream: categoryController.categoriesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay categorías aún.'));
                  }
                  final categories = snapshot.data!;
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryButton(
                        category: category,
                        onDelete: () {
                          _showDeleteConfirmationDialog(
                              context, categoryController, category.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCategoryDialog(
      BuildContext context, CategoryController categoryController) {
    TextEditingController nameController = TextEditingController();
    String selectedIcon = '📚';

    showDialog(
      context: context,
      builder: (context) {
        return CreateCategoryDialog(
          nameController: nameController,
          selectedIcon: selectedIcon,
          categoryController: categoryController,
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context,
    CategoryController categoryController, String categoryId) {
  categoryController.getCategoryById(categoryId).then((category) {
    if (category?.user_email == 'all_users@domain.com') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes eliminar una categoría global.'),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2E4A5A), // Fondo azul
            title: const Text(
              'Eliminar Categoría',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Texto blanco
            ),
            content: const Text(
              '¿Seguro que deseas eliminar esta categoría?',
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent), // Fondo transparente
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFFF44336)), // Fondo rojo
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                    ),
                  ),
                ),
                onPressed: () {
                  categoryController.deleteCategory(categoryId).then((_) {
                    Navigator.pop(context); // Cerrar el diálogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Categoría eliminada exitosamente.')),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al eliminar la categoría.')),
                    );
                  });
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Texto blanco
                ),
              ),
            ],
          );
        },
      );
    }
  });
}
}

class CreateCategoryDialog extends StatefulWidget {
  final TextEditingController nameController;
  final String selectedIcon;
  final CategoryController categoryController;

  CreateCategoryDialog({
    required this.nameController,
    required this.selectedIcon,
    required this.categoryController,
  });

  @override
  _CreateCategoryDialogState createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  String selectedIcon = '📚';
  Color selectedColor = Colors.red;

  final List<Color> colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.selectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2E4A5A), // Fondo azul oscuro
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Center(
        child: Text(
          'Crear Categoría',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Texto blanco
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Input para el nombre
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white, // Fondo blanco
            child: TextFormField(
              controller: widget.nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.black), // Texto negro
                border: InputBorder.none,
                prefixIcon: Icon(Icons.category, color: Colors.black), // Ícono negro
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Dropdown para seleccionar ícono
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white, // Fondo blanco
            child: DropdownButtonFormField<String>(
              value: selectedIcon,
              decoration: const InputDecoration(
                labelText: 'Seleccionar Logo',
                labelStyle: TextStyle(color: Colors.black), // Texto negro
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.0),
              ),
              items: ['📚', '🛒', '🎮', '💼', '🚗', '🍔', '🏠']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Center(child: Text(e)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedIcon = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          // Selector de color
          const Text(
            'Seleccionar Color',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Texto blanco
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: colorOptions.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == color ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botón Cancelar
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
            ),
            // Botón Agregar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5DA6A7), // Fondo verde
                foregroundColor: Colors.white, // Texto blanco
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                ),
              ),
              onPressed: () {
                if (widget.nameController.text.isNotEmpty) {
                  widget.categoryController
                      .addCategory(
                        widget.nameController.text,
                        selectedIcon,
                        selectedColor,
                      )
                      .then((_) {
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ],
    );
  }
}
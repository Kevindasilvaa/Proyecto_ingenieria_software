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
        backgroundColor: Color(0xFFCECECE),
        title: Text(
          'Categorías',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
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
    Color selectedColor = Colors.red;
    List<Color> colorOptions = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.green,
      Colors.pink,
      Colors.grey
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              'Crear Categoría',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Nombre de la categoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedIcon,
                decoration: InputDecoration(
                  labelText: 'Seleccionar Logo',
                  border: OutlineInputBorder(),
                ),
                items: ['📚', '🛒', '🎮', '💼', '🚗', '🍔', '🏠']
                    .map((e) => DropdownMenuItem(
                        value: e, child: Center(child: Text(e))))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedIcon = value;
                },
              ),
              SizedBox(height: 16),
              Text('Seleccionar Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      selectedColor = color;
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: selectedColor == color
                                ? Colors.black
                                : Colors.transparent,
                            width: 2),
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      categoryController
                          .addCategory(
                              nameController.text, selectedIcon, selectedColor)
                          .then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text('Agregar'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context,
      CategoryController categoryController, String categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Categoría'),
          content: Text('¿Seguro que deseas eliminar esta categoría?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                categoryController.deleteCategory(categoryId).then((_) {
                  Navigator.pop(context);
                });
              },
              child: Text('Eliminar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:moni/models/clases/category.dart';

class CategoryButton extends StatelessWidget {
  final Category category;
  final VoidCallback onDelete;

  const CategoryButton({
    required this.category,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.2), // Fondo con transparencia
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: category.color,
                radius: 20,
                child: Text(
                  category.icon,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(width: 12),
              Text(
                category.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

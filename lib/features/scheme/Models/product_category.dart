
import 'package:flutter/material.dart' show IconData;

import '../Models/Product.dart';

class ProductCategory {
  ProductType type;
  bool isSelected;
  IconData icon;

  ProductCategory(this.type, this.isSelected, this.icon);
}

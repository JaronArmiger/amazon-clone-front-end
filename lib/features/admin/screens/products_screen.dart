import 'package:amazon_clone_tutorial/features/admin/screens/add_products_screen.dart';
import 'package:amazon_clone_tutorial/features/admin/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../common/widgets/loader.dart';
import '../../../models/product.dart';
import '../../account/widgets/single_product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product>? products;
  final AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminService.fetchAllProducts(context);
    if (mounted) {
      setState(() {});
    }
  }

  void navigateToAddProducts() {
    Navigator.pushNamed(context, AddProductsScreen.routeName);
  }

  void deleteProduct(Product product, int index) {
    adminService.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(children: [
                  SizedBox(
                    height: 140,
                    child: SingleProduct(
                      image: productData.images[0],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          productData.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteProduct(productData, index),
                        icon: const Icon(
                          Icons.delete_outline,
                        ),
                      ),
                    ],
                  ),
                ]);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProducts,
              tooltip: 'Add a Product',
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

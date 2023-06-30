import 'dart:convert';

import 'package:amazon_clone_tutorial/common/snackbar_global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/env_vars.dart';
import '../../../constants/error_handling.dart';
import '../../../models/product.dart';
import 'package:http/http.dart' as http;

import '../../../providers/user_provider.dart';

class HomeService {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products-by-category?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      var decodedRes = jsonDecode(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < decodedRes.length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  decodedRes[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      SnackbarGlobal.show(e.toString());
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
    );
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/deal-of-day'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      var decodedRes = jsonDecode(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      SnackbarGlobal.show(e.toString());
    }
    return product;
  }
}

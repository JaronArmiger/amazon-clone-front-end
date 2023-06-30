import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../common/snackbar_global.dart';
import '../../../constants/env_vars.dart';
import '../../../constants/error_handling.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';

class SearchService {
  Future<List<Product>> fetchSearchedProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
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
}

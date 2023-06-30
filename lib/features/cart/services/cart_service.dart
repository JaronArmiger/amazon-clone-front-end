import 'dart:convert';

import 'package:amazon_clone_tutorial/common/snackbar_global.dart';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constants/env_vars.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class CartService {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            cart: jsonDecode(res.body)['cart'],
          );
          userProvider.setUserFromModel(user);
          SnackbarGlobal.show('${product.name} removed from cart!');
        },
      );
    } catch (e) {
      SnackbarGlobal.show(e.toString());
    }
  }
}

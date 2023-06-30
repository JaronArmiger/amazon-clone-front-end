import 'dart:convert';

import 'package:amazon_clone_tutorial/common/snackbar_global.dart';
// import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      SnackbarGlobal.show(jsonDecode(response.body)['msg']);
      // showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      // showSnackBar(context, jsonDecode(response.body)['error']);
      SnackbarGlobal.show(jsonDecode(response.body)['error']);
      break;
    default:
      // showSnackBar(context, response.body);
      SnackbarGlobal.show(jsonDecode(response.body));
  }
}

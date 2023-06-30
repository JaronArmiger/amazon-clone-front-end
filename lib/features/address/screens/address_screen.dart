import 'package:amazon_clone_tutorial/common/snackbar_global.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../../../providers/user_provider.dart';
import 'package:amazon_clone_tutorial/constants/applepay_config.dart';
import 'package:amazon_clone_tutorial/constants/googlepay_config.dart';

import '../services/address_service.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  String addressToBeUsed = '';
  List<PaymentItem> paymentItems = [];
  final AddressService addressService = AddressService();

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _flatBuildingController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
  }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressService.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressService.placeOrder(
      context: context,
      address: addressToBeUsed,
      orderTotal: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressService.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressService.placeOrder(
      context: context,
      address: addressToBeUsed,
      orderTotal: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = '';

    bool formHasValues = _flatBuildingController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;

    if (formHasValues) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${_flatBuildingController.text} ${_areaController.text}, ${_cityController.text} ${_pincodeController.text}';
      } else {
        throw Exception('Please enter full address.');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      SnackbarGlobal.show('ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    // var address = '101 fake street';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('OR', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _flatBuildingController,
                      hintText: 'Flat, House no., Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              ApplePayButton(
                onPressed: () => payPressed(address),
                width: double.infinity,
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultApplePay),
                onPaymentResult: onApplePayResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                height: 50,
              ),
              const SizedBox(height: 10),
              GooglePayButton(
                onPressed: () => payPressed(address),
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultGooglePay),
                onPaymentResult: onGooglePayResult,
                paymentItems: paymentItems,
                height: 50,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

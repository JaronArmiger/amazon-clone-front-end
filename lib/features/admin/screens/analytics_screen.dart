import 'package:amazon_clone_tutorial/features/admin/services/admin_service.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../models/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminService adminService = AdminService();
  int? totalEarnings;
  List<Sales>? earningsByCategory;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminService.getEarnings(context);
    totalEarnings = earningData['totalEarnings'];
    earningsByCategory = earningData['sales'];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return earningsByCategory == null || totalEarnings == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '\$$totalEarnings',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 250,
                // child: CategoryProducts
              ),
            ],
          );
  }
}

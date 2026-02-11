import 'package:flutter/material.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: appColors.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 13,
      letterSpacing: 0.5,
    );

    const labelStyle = TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );

    const valueStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    const boldValueStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Scaffold(
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Powered by  ',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryColor,
                letterSpacing: 1,
                fontWeight: FontWeight.w200,
                fontSize: height / 28,
              ),
            ),
            Image.asset(
              'assets/temp/settu_logo.png',
              height: height / 14,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/icons/bbps_logo.png',
                    height: height / 12,
                  ),

                  Image.asset(
                    'assets/images/bbps_assured.png',
                    height: height / 5,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text("BILL DETAILS", style: titleStyle),
              const SizedBox(height: 12),
              _buildRow("Biller’s name", "Tata Power - Delhi"),
              _buildRow("Bill Date", "June 12, 2025"),
              const SizedBox(height: 8),
              _buildRow("Bill amount", "₹5,000",
                  valueTextStyle: boldValueStyle),
              const SizedBox(height: 12),

              Divider(
                color: Colors.orangeAccent.withValues(alpha: 0.25),
                thickness: 2,
              ),
              const SizedBox(height: 12),

              Text("PAYMENT DETAILS", style: titleStyle),
              const SizedBox(height: 12),
              _buildRow("Payment reference ID", "ABCDE1234E"),
              _buildRow("Payment mode", "UPI"),
              const SizedBox(height: 8),
              _buildRow("B-Connect transaction ID", "12323435465756464"),
              _buildRow("Transaction date and time", "12:30 PM, 12.05.2025"),
              const SizedBox(height: 8),
              _buildRow("Customer convenience fee", "₹1"),
              _buildRow("Amount paid", "₹5,001",
                  valueTextStyle: boldValueStyle),
              const SizedBox(height: 12),

              Divider(
                color: Colors.orangeAccent.withValues(alpha: 0.25),
                thickness: 2,
              ),
              const SizedBox(height: 12),
              Text("CUSTOMER DETAILS", style: titleStyle),
              const SizedBox(height: 12),
              _buildRow("Customer Name", "Satyam kumar",
                  valueTextStyle: boldValueStyle),
              _buildRow("Mobile Number", "7011005488"),
              const SizedBox(height: 8),
              _buildRow("Customer ID / Account ID", "SATYAM@DKD"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {TextStyle? valueTextStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(
            child: Text(
              value,
              style: valueTextStyle ?? const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

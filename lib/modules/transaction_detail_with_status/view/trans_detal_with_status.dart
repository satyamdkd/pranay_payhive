import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import '../controller/trans_detal_with_status_controller.dart';
import 'package:intl/intl.dart';

class TransactionDetailWithStatus
    extends GetView<TransactionDetailWithStatusController> {
  const TransactionDetailWithStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar(),
          SliverToBoxAdapter(
            child: GetBuilder(
                init: controller,
                builder: (ctx) {
                  return controller.loader.value
                      ? loader()
                      : controller.transactionDetails == null ||
                              controller.transactionDetails?['data'] == null
                          ? noDataAvailable()
                          : myBody(context);
                }),
          ),
        ],
      ),
    );
  }

  Container noDataAvailable() {
    return Container(
      height: height / 0.6,
      alignment: Alignment.center,
      child: Text(
        "NO DATA AVAILABLE!",
        textAlign: TextAlign.center,
        style: theme.textTheme.labelMedium?.copyWith(
          color: appColors.grey.withValues(alpha: 0.6),
          letterSpacing: 1,
          fontWeight: FontWeight.w900,
          fontSize: height / 20,
        ),
      ),
    );
  }

  Center loader() {
    return Center(
      child: SizedBox(
        height: height * 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/wave_loading.json',
              width: width / 2,
              height: height / 5,
            ),
            Text(
              "Loading...",
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.grey,
                letterSpacing: 2,
                fontWeight: FontWeight.w800,
                fontSize: height / 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myBody(BuildContext context) {
    final String status =
        controller.transactionDetails!['data']['status'] ?? 'success';
    final StatusUIModel statusUI = _getStatusUI(status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(context, controller.transactionDetails!, statusUI),
          const SizedBox(height: 12),
          if (status == 'pending' ||
              status == 'created' ||
              status == 'failed' ||
              status == 'Unpaid' ||
              status == 'UnPaid') ...[
            _buildInfoCard(context),
            const SizedBox(height: 16),
          ],
          if (controller.transactionDetails!['data']['customerParams'] !=
              null) ...[
            buildCustomerParamsCard(context, controller.transactionDetails!),
            const SizedBox(height: 12),
          ],
          if (controller.transactionDetails?['data']['paymentcard_data'] !=
              null) ...[
            _buildPaymentMethodCard(
              context,
              controller.transactionDetails?['data']['paymentcard_data'],
            ),
            const SizedBox(height: 12),
          ],
          ...[
            _buildTransactionSummaryCard(
                context, controller.transactionDetails!, statusUI.color),
            const SizedBox(height: 12),
          ],
          if ((controller.transactionDetails?['data']['admin_wallet'] as List)
              .isNotEmpty)
            _buildWalletDetailsCard(
              context,
              controller.transactionDetails!,
            ),
        ],
      ),
    );
  }

  /// Builds the card showing details of the payment method used.
  Widget _buildPaymentMethodCard(
      BuildContext context, dynamic paymentCardData) {
    /// --- Safely extract payment card data ---
    final cardData = paymentCardData['card'];
    final status =
        paymentCardData['status']?.toString().capitalizeFirst ?? 'N/A';
    final orderId = paymentCardData['order_id'] ?? 'N/A';
    final isInternational = paymentCardData['international'] ?? false;
    final last4 = cardData?['last4'] ?? 'XXXX';
    final network = cardData?['network'] ?? 'N/A';
    final issuer = cardData?['issuer'] ?? 'N/A';
    final type = cardData?['type']?.toString().capitalizeFirst ?? 'N/A';

    /// --- Handle refund data ---
    final amountRefundedNum = paymentCardData['amount_refunded'] ?? 0;
    final amountRefunded = (amountRefundedNum is int ? amountRefundedNum : 0);
    final formattedAmountRefunded =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹')
            .format(amountRefunded);
    final refundStatus = paymentCardData['refund_status'];

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: height / 22,
              ),
            ),
            const SizedBox(height: 8),
            Divider(
              color: Colors.grey.withValues(alpha: 0.1),
              thickness: 1.5,
            ),
            const SizedBox(height: 12),

            /// Using a more visually appealing layout for card details
            Row(
              children: [
                /// You can add a dynamic card icon here based on the network if you want
                Icon(Icons.credit_card,
                    color: appColors.primaryColor, size: 40),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$network $type Card',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '•••• $last4 ($issuer)',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: appColors.grey),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: Colors.grey.withValues(alpha: 0.1),
              thickness: 1.5,
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Order ID:', orderId),
            const SizedBox(height: 12),
            _buildDetailRow('Payment Status:', capitalizeFirstCharacter(status),
                valueColor: status.toLowerCase() == 'captured'
                    ? Colors.green.shade700
                    : Colors.orange),
            const SizedBox(height: 12),
            _buildDetailRow('International:', isInternational ? 'Yes' : 'No'),

            /// Conditionally show refund status
            if (amountRefunded > 0) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Amount Refunded:', formattedAmountRefunded),
            ],
            if (refundStatus != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                  'Refund Status:', '$refundStatus'.capitalizeFirst!),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the top card showing payment status, amount, and date.
  Widget _buildStatusCard(
      BuildContext context, dynamic transactionDetail, StatusUIModel statusUI) {
    final amountStr = transactionDetail['data']['amount']?.toString();
    final amount = double.tryParse(amountStr ?? "0") ?? 0.0;

    final formattedAmount =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount);
    final dateTime = transactionDetail['data']['created_at'];

    DateTime parsedDate = DateTime.parse(dateTime ?? "0000-00-00 00:00:00");
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction ${statusUI.text}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: height / 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedAmount,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: height / 18,
                      letterSpacing: 1,
                      color: appColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: appColors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            AnimatedScaleIconCircleAvatar(
              color: statusUI.color,
              icon: statusUI.icon,
              height: height,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the informational card for pending transactions.
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: appColors.primaryColor.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "IMPORTANT",
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: appColors.primaryColor,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We are continuously checking the status of your payment. Banks may take upto 3-5 working days to confirm the final status. If this payment fails, your bank will automatically refund the money to your account.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper function to get UI properties based on transaction status.
  StatusUIModel _getStatusUI(String status) {
    switch (status.toLowerCase()) {
      case 'success' || 'paid':
        return StatusUIModel(
            text: 'Successful',
            color: Colors.green,
            icon: Icons.check_circle_rounded);
      case 'failed' || 'fail' || 'unpaid':
        return StatusUIModel(
            text: 'failed', color: Colors.red, icon: Icons.cancel_rounded);
      case 'pending' || 'created':
      default:
        return StatusUIModel(
            text: 'Pending', color: Colors.orange, icon: Icons.error_rounded);
    }
  }

  /// Builds a beautifully designed card showing a high-level summary of the transaction.
  /// This widget uses static values for design purposes.
  Widget _buildTransactionSummaryCard(
      BuildContext context, dynamic transactionDetail, color) {
    var status = transactionDetail['data']['status'];
    var orderId = transactionDetail['data']['order_id'];
    var transactionType = controller.source!.toUpperCase();
    var formattedBalance = transactionDetail['availableBalance'];

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Summary',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: height / 22,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              context,
              icon: Icons.check_circle_outline_rounded,
              label: 'Status',
              value: capitalizeFirstCharacter(
                  status.toString().toLowerCase().contains('created')
                      ? 'Pending'
                      : status),
              valueColor: color,
            ),
            if (orderId != null)
              Divider(
                color: Colors.grey.withValues(alpha: 0.1),
                thickness: 1.5,
                height: 24,
              ),
            if (orderId != null)
              _buildSummaryRow(
                context,
                icon: Icons.receipt_long_outlined,
                label: 'Order ID',
                value: orderId,
              ),
            Divider(
              color: Colors.grey.withValues(alpha: 0.1),
              thickness: 1.5,
              height: 24,
            ),
            _buildSummaryRow(
              context,
              icon: Icons.credit_card_outlined,
              label: 'Payment Method',
              value: transactionType.toLowerCase().contains('pos')
                  ? "P.O.S"
                  : transactionType.toLowerCase().contains('bbps')
                      ? "BBPS"
                      : capitalizeFirstCharacter(transactionType),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: appColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: appColors.primaryColor.withOpacity(0.1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Available Balance',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: appColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedBalance.toString(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: appColors.primaryColor.withValues(alpha: 0.8),
                    size: 36,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCustomerParamsCard(BuildContext context, dynamic customerParams) {
    final theme = Theme.of(context);
    final String? mobile = customerParams['data']['customerParams']['mobile'];
    final List<dynamic> params =
        customerParams['data']['customerParams']['customerParams'] ?? [];

    final String? regMobile = params.firstWhere(
      (e) => (e['name'] as String).toLowerCase().contains('mobile'),
      orElse: () => {'value': mobile},
    )['value'];
    final String? last4 = params.firstWhere(
      (e) => (e['name'] as String).toLowerCase().contains('last 4'),
      orElse: () => {'value': '----'},
    )['value'];

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Details',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: height / 22,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone_iphone_rounded,
                      color: Colors.green, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Registered Mobile Number",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        regMobile ?? '----',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sim_card_rounded,
                      color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last 4 Digits",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '**** $last4' ?? '----',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to create a consistent and beautiful row for the summary card.
  Widget _buildSummaryRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: appColors.grey, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: appColors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? theme.textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the card showing the breakdown of wallet transactions.
  Widget _buildWalletDetailsCard(
      BuildContext context, dynamic transactionDetail) {
    /// --- Safely extract wallet data ---
    final adminWallet =
        (transactionDetail['data']['admin_wallet'] as List).isNotEmpty
            ? transactionDetail['data']['admin_wallet'][0]
            : null;
    final userWallet =
        (transactionDetail['data']['user_wallet'] as List).isNotEmpty
            ? transactionDetail['data']['user_wallet'][0]
            : null;
    final userWallet2 =
        (transactionDetail['data']['user_wallet'] as List).length > 1
            ? transactionDetail['data']['user_wallet'][1]
            : null;

    /// --- Format Admin Amount ---
    final adminAmountStr = adminWallet?['margin_amt']?.toString() ?? '0';
    final adminAmount = double.tryParse(adminAmountStr) ?? 0.0;
    final formattedAdminAmount =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(adminAmount);
    final adminType = adminWallet?['type'] ?? 'N/A';

    /// --- Format User Amount ---
    final userAmountStr = userWallet?['balance_amt']?.toString() ?? '0';
    final userAmountStr2 = userWallet2?['balance_amt']?.toString() ?? '0';
    final userAmount = double.tryParse(userAmountStr) ?? 0.0;
    final userAmount2 = double.tryParse(userAmountStr2) ?? 0.0;
    final formattedUserAmount =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(userAmount);
    final formattedUserAmount2 =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(userAmount2);
    final userType = userWallet?['type'] ?? 'N/A';
    final userType2 = userWallet2?['type'] ?? 'N/A';

    /// --- Transaction Info ---
    final transactionId = transactionDetail['data']['transid'] ?? 'N/A';
    final dateTimeStr = transactionDetail['data']['created_at'];
    DateTime parsedDate =
        DateTime.tryParse(dateTimeStr ?? "") ?? DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Breakdown',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: height / 22,
              ),
            ),
            const SizedBox(height: 12),
            Divider(
              color: Colors.grey.withValues(alpha: 0.1),
              thickness: 1.5,
            ),
            if (transactionId != 'N/A') const SizedBox(height: 12),
            if (transactionId != 'N/A')
              _buildDetailRow('Transaction ID:', transactionId,
                  valueColor: Colors.black),
            const SizedBox(height: 4),
            _buildDetailRow(
                '${transactionDetail['data']['user_wallet'][0]['trans-type']} :',
                '$formattedUserAmount ($userType)',
                valueColor: userType.toString().trim().toLowerCase() == 'credit'
                    ? Colors.green.shade700
                    : Colors.red),
            const SizedBox(height: 2),
            if (transactionDetail['data']['user_wallet'].length > 1)
              _buildDetailRow(
                  '${transactionDetail['data']['user_wallet'][1]['trans-type']} :',
                  '$formattedUserAmount2 ($userType2)',
                  valueColor:
                      userType.toString().trim().toLowerCase() == 'credit'
                          ? Colors.green.shade700
                          : Colors.red),
            const SizedBox(height: 6),

            /// _buildDetailRow(
            ///     'Admin Wallet:', '$formattedAdminAmount ($adminType)',
            ///     valueColor:
            ///         adminType.toString().trim().toLowerCase() == 'credit'
            ///             ? Colors.green.shade700
            ///             : Colors.red),
            const SizedBox(height: 6),
            _buildDetailRow('Transaction Date:', formattedDate,
                valueColor: Colors.black),
          ],
        ),
      ),
    );
  }

  /// Helper to create a consistent row for details.
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
              color: appColors.black.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
              fontSize: height / 32,
              letterSpacing: 1),
        ),
        Flexible(
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontSize: height / 32,
                letterSpacing: 1),
          ),
        ),
      ],
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColors.primaryColor,
      expandedHeight: height / 4.6,
      floating: false,
      pinned: true,
      forceElevated: true,
      stretch: true,
      title: null,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: appColors.primaryColor),
            Image.asset('assets/images/flare_two.png', fit: BoxFit.fitHeight),
            Container(
              margin: EdgeInsets.only(
                left: width / 30,
                bottom: width / 20,
                right: width / 30,
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [backButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector backButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                size: height / 18,
                color: appColors.primaryExtraLight,
              ),
              SizedBox(width: width / 80),
              Text(
                'Transaction Details',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400,
                  fontSize: height / 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A simple data model for status-specific UI elements.
class StatusUIModel {
  final String text;
  final Color color;
  final IconData icon;

  StatusUIModel({required this.text, required this.color, required this.icon});
}

class AnimatedScaleIconCircleAvatar extends StatefulWidget {
  final Color color;
  final IconData icon;
  final double height;

  const AnimatedScaleIconCircleAvatar({
    required this.color,
    required this.icon,
    required this.height,
    super.key,
  });

  @override
  State<AnimatedScaleIconCircleAvatar> createState() =>
      _AnimatedScaleIconCircleAvatarState();
}

class _AnimatedScaleIconCircleAvatarState
    extends State<AnimatedScaleIconCircleAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scale = Tween<double>(begin: 0.5, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.height / 16,
      backgroundColor: widget.color.withValues(alpha: 0.15),
      child: ScaleTransition(
        scale: _scale,
        child: Icon(
          widget.icon,
          color: widget.color,
          size: widget.height / 16,
        ),
      ),
    );
  }
}

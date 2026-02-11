import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/error.dart';
import '../../../../services/di/di.dart';
import '../controller/credit_card_controller.dart';

class FetchedCreditCardBill extends GetView<CredCardController> {
  const FetchedCreditCardBill({
    super.key,
    required this.bankName,
    required this.last4Digits,
    required this.logo,
  });

  final String last4Digits;
  final String bankName;
  final String? logo;

  Container consentCard(double height) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(height / 50),
      ),
      padding: EdgeInsets.all(height / 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height / 120),
            child: Image.asset(
              'assets/icons/bbps_logo.png',
              height: height / 24,
            ),
          ),
          SizedBox(width: height / 60),
          Expanded(
            child: Text(
              'By proceeding further, you allow Payhive to store your bill details, fetch current and future bills, and send you reminders',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: height / 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: poweredBySetu(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar(),
          SliverToBoxAdapter(
            child: GetBuilder<CredCardController>(
              init: controller,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [body(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding poweredBySetu() {
    return Padding(
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
    );
  }

  body(context) {
    final height = MediaQuery.of(context).size.height;

    final radius = BorderRadius.only(
        bottomRight: Radius.circular(height * 0.018),
        bottomLeft: Radius.circular(height * 0.018));
    final smallRadius = BorderRadius.circular(height * 0.006);

    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontSize: height * 0.018,
      fontWeight: FontWeight.w700,
      letterSpacing: 1,
      color: theme.colorScheme.onSurface,
    );

    final subStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: height * 0.016,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF6C6C6C),
      letterSpacing: 2,
    );

    final rowLabel = theme.textTheme.bodyMedium?.copyWith(
      fontSize: height * 0.014,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
    );

    final rowValue = theme.textTheme.bodyMedium?.copyWith(
      fontSize: height * 0.014,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
      letterSpacing: 0.8,
    );

    /// Amount style based on your requirement
    final amountStyle = theme.textTheme.headlineSmall?.copyWith(
      fontSize: height / 28,
      fontWeight: FontWeight.w500,
      letterSpacing: 1,
    );

    final dueStyle = theme.textTheme.bodyMedium?.copyWith(
        fontSize: height * 0.016,
        color: appColors.red,
        fontWeight: FontWeight.w600,
        letterSpacing: 1);

    final cardShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 10,
        offset: const Offset(0, 3),
      )
    ];

    final totalAmountText = controller.moneyFromPaise(controller.amountPaise);

    final minDueText =
        controller.moneyFromString(controller.minimumDueFromAdditional);
    final maxPerText =
        controller.moneyFromString(controller.maxAmtPermissibleFromAdditional);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: theme.colorScheme.surface, borderRadius: radius),
          padding: EdgeInsets.all(height * 0.018),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header: logo + name + masked number
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _LogoCircle(
                    url: logo,
                    size: height * 0.060,
                    bgColor: const Color(0xFFB83AB1),
                    bankName: bankName,
                  ),
                  SizedBox(width: height * 0.014),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bankName, style: titleStyle),
                        SizedBox(height: height * 0.004),
                        Text('XXXX $last4Digits', style: subStyle),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.016),
              const Divider(height: 1.0, color: Color(0xFFE7E8EC)),
              SizedBox(height: height * 0.010),

              /// Bill details rows
              ...[
                _detailRow('Customer Name', controller.customerName, rowLabel!,
                    rowValue!, height),
                _detailRow(
                    'Bill Date',
                    controller.billDateUi.isEmpty ? '-' : controller.billDateUi,
                    rowLabel,
                    rowValue,
                    height),
                if (controller.currentOutStandingFromAdditional.toString() !=
                    'null')
                  _detailRow(
                      'Current Outstanding Amount',
                      '₹ ${controller.currentOutStandingFromAdditional} ',
                      rowLabel,
                      rowValue,
                      height),
                _detailRow(
                    'Minimum Payable\nAmount',
                    minDueText.replaceAll(controller.rupee, '').trim(),
                    rowLabel,
                    rowValue,
                    height),
                if (maxPerText.replaceAll(controller.rupee, '').trim() != '0')
                  _detailRow(
                      'Maximum Permissible\nAmount',
                      maxPerText.replaceAll(controller.rupee, '').trim(),
                      rowLabel,
                      rowValue,
                      height),
                SizedBox(height: height * 0.012),
              ],

              /// Amount box (editable TextField without underline)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: smallRadius,
                  border: Border.all(color: const Color(0xFFDFE3EA), width: 1),
                  boxShadow: cardShadow,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: height * 0.018, vertical: height * 0.016),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹ ',
                          style: amountStyle?.copyWith(
                                fontWeight: FontWeight.w600,
                              ) ??
                              TextStyle(
                                fontSize: height / 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.amountCtrl,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}$')),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: amountStyle,
                            onChanged: (v) {
                              controller.amountCtrl.text =
                                  controller.amountCtrl.text.trim();
                              controller.amountCtrl.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: controller.amountCtrl.text.length),
                              );
                              controller.update();
                            },
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.012),
                    const Divider(color: Color(0xFFE7E8EC), height: 1.0),
                    SizedBox(height: height * 0.010),
                    Text(
                      'Due Date: ${controller.dueDateUi.isEmpty ? '-' : controller.dueDateUi}',
                      style: dueStyle,
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.016),

              /// Toggle pills
              Row(
                children: [
                  Expanded(
                    child: _pillToggle(
                      height: height,
                      title: 'Total Amount',
                      value: totalAmountText.replaceAll(' ', ''),
                      isSelected: controller.selectedPill == 'total',
                      onTap: () => controller.setAmountFrom(
                        'total',
                        totalAmountText
                            .replaceAll('₹', '')
                            .replaceAll(',', '')
                            .trim(),
                      ),
                    ),
                  ),
                  SizedBox(width: height * 0.014),
                  Expanded(
                    child: _pillToggle(
                      height: height,
                      title: 'Minimum Due',
                      value: minDueText.replaceAll(' ', ''),
                      isSelected: controller.selectedPill == 'min',
                      onTap: () => controller.setAmountFrom(
                        'min',
                        minDueText
                            .replaceAll('₹', '')
                            .replaceAll(',', '')
                            .trim(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 40),
              bankWillConsider(height),
              SizedBox(height: height / 80),
              consentCard(MediaQuery.sizeOf(context).height / 2),
              if (controller.amountCtrl.text.isNotEmpty)
                SizedBox(height: height / 80),
              if (controller.amountCtrl.text.isNotEmpty)
                controller.paymentRequestLoader.value
                    ? Center(
                        child: Lottie.asset(
                          'assets/lottie/wave_loading.json',
                          width: width,
                          height: height / 8,
                        ),
                      )
                    : customButton(
                        title: 'Proceed to pay',
                        onTap: () async {
                          final maxAmount =
                              controller.maxAmtPermissibleFromAdditional;
                          final enteredAmount =
                              double.tryParse(controller.amountCtrl.text) ?? 0;

                          if (maxAmount != null &&
                              double.tryParse(maxAmount)! < enteredAmount) {
                            errorDialog(
                              context: context,
                              message:
                                  'You can currently pay up to ₹$maxAmount, as your maximum permissible amount is less than the amount you entered.',
                            );
                          } else if (double.parse(minCreditCardBillPay) >
                              enteredAmount) {
                            errorDialog(
                              context: context,
                              message:
                                  'The minimum amount should be greater than or equal to 100',
                            );
                          } else {
                            controller.billPaymentRequest();
                          }
                        },
                        context: context,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: appColors.white,
                          fontSize: height / 50,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
            ],
          ),
        ),
      ],
    );
  }

  Container bankWillConsider(double height) {
    return Container(
      padding: EdgeInsets.all(height / 80),
      decoration: BoxDecoration(
        color: appColors.primaryColor
            .withValues(alpha: 0.1), // background color (dark mode look)
        borderRadius: BorderRadius.circular(8),

        border: Border(
            left: BorderSide(
                color: appColors.primaryColor, width: height * 0.01)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Note : ",
                    style: TextStyle(
                      color: appColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: height / 66,
                    ),
                  ),
                  TextSpan(
                    text:
                        "$bankName will consider today's date as payment date. It may take upto 30 minutes to reflect in account.",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: height / 76,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------

  Widget _detailRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
    double height,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.006),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 11,
            child: Text(label, style: labelStyle),
          ),
          Expanded(
            flex: 1,
            child: Text(':', style: labelStyle),
          ),
          Expanded(
            flex: 12,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(value, style: valueStyle),
            ),
          ),
        ],
      ),
    );
  }
}

// Toggle pill widget (uses textTheme)
Widget _pillToggle({
  required double height,
  required String title,
  required String value,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  const borderColor = Color(0xFF6C3AB2);
  final fillColor =
      isSelected ? borderColor.withValues(alpha: 0.07) : Colors.white;

  return InkWell(
    borderRadius: BorderRadius.circular(height * 0.005),
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(height * 0.005),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: height * 0.018, vertical: height * 0.006),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title from textTheme
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: height * 0.014,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: height * 0.004),
          // Value from textTheme
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: height * 0.022,
              color: borderColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ),
  );
}

// Circular logo with fallback initials
class _LogoCircle extends StatelessWidget {
  const _LogoCircle({
    required this.url,
    required this.size,
    required this.bgColor,
    required this.bankName,
  });

  final String? url;
  final double size;
  final Color bgColor;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    final initials = _computeInitials(bankName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: (url != null && url!.trim().isNotEmpty)
          ? Image.network(
              url!.trim(),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(initials),
            )
          : _fallback(initials),
    );
  }

  Widget _fallback(String initials) => Center(
        child: Text(
          initials,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      );

  // Computes initials per the specified rules
  String _computeInitials(String name) {
    final raw = (name).trim();
    if (raw.isEmpty) return 'CC';

    final words = raw
        .split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'[^A-Za-z]'), ''))
        .where((w) => w.isNotEmpty)
        .toList();

    if (words.isEmpty) return 'CC';

    if (words.first.length == 2) {
      return words.first.toUpperCase();
    }

    const ignore = {
      'of',
      'the',
      'and',
      'for',
      'to',
      'in',
      'on',
      'by',
      'with',
      'a',
      'an',
      'credit',
      'card',
      'bank'
    };

    final significant = <String>[];
    for (final w in words) {
      final lw = w.toLowerCase();
      if (!ignore.contains(lw)) significant.add(w);
      if (significant.length == 3) break;
    }

    final source = significant.isEmpty ? words.take(3).toList() : significant;
    final letters = source.map((w) => w.characters.first).join();
    return letters.substring(0, letters.length.clamp(1, 3)).toUpperCase();
  }
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
              'Pay credit card bill',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w300,
                fontSize: height / 22,
              ),
            ),
          ],
        ),
        SizedBox(width: width / 5.2),
        Image.asset(
          'assets/home/bbps_white_logo.png',
          height: height / 10,
        ),
      ],
    ),
  );
}

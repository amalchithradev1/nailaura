import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nailauraweb/core/constants.dart';
import 'package:nailauraweb/core/theme.dart';

class InvoiceScreen extends StatefulWidget {
  final Map<String, String> queryParams;

  const InvoiceScreen({super.key, required this.queryParams});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  int? _selectedRating; // 0 = Most Likely, 1 = Probably, 2 = Least Likely
  bool _ratingSubmitted = false;

  String get invoiceNumber => widget.queryParams['inv'] ?? 'INV-1000';
  String get customerName => widget.queryParams['name'] ?? 'Valued Customer';
  String get phone => widget.queryParams['phone'] ?? '+91 ----------';
  String get dateStr => widget.queryParams['date'] ?? '12/09/2026';
  String get totalStr => widget.queryParams['total'] ?? '0.00';
  String get rawItems => widget.queryParams['items'] ?? '';

  List<Map<String, String>> get itemsList {
    if (rawItems.isEmpty) {
      return [
        {'name': 'Luxury Nail Art Service', 'price': totalStr}
      ];
    }

    final list = <Map<String, String>>[];
    final parts = rawItems.split('|');
    for (var part in parts) {
      if (part.contains(':')) {
        final lastIdx = part.lastIndexOf(':');
        final name = part.substring(0, lastIdx).trim();
        final price = part.substring(lastIdx + 1).trim();
        list.add({'name': name, 'price': price});
      } else {
        list.add({'name': part.trim(), 'price': '0.00'});
      }
    }
    return list;
  }

  double get totalAmount => double.tryParse(totalStr) ?? 0.0;

  Future<Uint8List> _generatePdfBytes() async {
    final pdf = pw.Document();

    pw.MemoryImage? logoIconImage;
    pw.MemoryImage? logoTextImage;
    try {
      final iconData = await rootBundle.load('assets/images/logo_icon_gold.png');
      final textData = await rootBundle.load('assets/images/logo_text_gold.png');
      logoIconImage = pw.MemoryImage(iconData.buffer.asUint8List());
      logoTextImage = pw.MemoryImage(textData.buffer.asUint8List());
    } catch (_) {}

    final goldColor = PdfColor.fromHex('#C5A059');
    final darkGoldColor = PdfColor.fromHex('#A37F38');
    final borderColor = PdfColor.fromHex('#ECE6DD');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with Official Gold Brand Logos
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoIconImage != null && logoTextImage != null)
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Image(logoIconImage, width: 48, height: 48, fit: pw.BoxFit.contain),
                        pw.SizedBox(width: 12),
                        pw.Image(logoTextImage, height: 36, fit: pw.BoxFit.contain),
                      ],
                    )
                  else
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'NAILAURA',
                          style: pw.TextStyle(
                            fontSize: 26,
                            fontWeight: pw.FontWeight.bold,
                            color: goldColor,
                          ),
                        ),
                        pw.Text(
                          'THE NAILART STUDIO',
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: darkGoldColor,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#F6EFD9'),
                          borderRadius: pw.BorderRadius.circular(6),
                          border: pw.Border.all(color: goldColor, width: 0.8),
                        ),
                        child: pw.Text(
                          'INVOICE RECEIPT',
                          style: pw.TextStyle(
                            color: darkGoldColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text('Invoice #: $invoiceNumber', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      pw.Text('Date: $dateStr', style: const pw.TextStyle(fontSize: 10)),
                      pw.Text('Status: PAID', style: pw.TextStyle(fontSize: 10, color: PdfColor.fromHex('#2E7D32'), fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F9F6F0'),
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: borderColor, width: 0.5),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Location: Kulathoor, Trivandrum - 695583', style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800)),
                    pw.Text('Phone: +91 8281791180', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: darkGoldColor)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // Customer Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Customer Name: $customerName', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.Text('Mobile: $phone', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.SizedBox(height: 14),

              // Items Table
              pw.Table(
                border: pw.TableBorder.all(color: borderColor, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColor.fromHex('#171719')),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Service Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColor.fromHex('#C5A059'))),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.white), textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Amount (Rs.)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColor.fromHex('#C5A059')), textAlign: pw.TextAlign.right),
                      ),
                    ],
                  ),
                  ...itemsList.map((item) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(item['name'] ?? '', style: const pw.TextStyle(fontSize: 10))),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('1', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Rs. ${item['price']}', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right)),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 16),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 220,
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 10)),
                            pw.Text('Rs. ${totalAmount.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.Divider(color: borderColor),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total Amount:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                            pw.Text('Rs. ${totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: goldColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // 15-Day Warranty Box
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F6EFD9'),
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: goldColor, width: 0.6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('15-DAY SERVICE WARRANTY POLICY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5, color: darkGoldColor)),
                    pw.SizedBox(height: 4),
                    pw.Text('• We provide an exclusive 15-day service warranty on gel extensions and structured nail art.', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800)),
                    pw.Text('• Please retain this digital receipt for touch-ups or warranty inquiries within 15 days.', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800)),
                    pw.Text('• Services performed are non-refundable after service completion.', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800)),
                  ],
                ),
              ),

              pw.Spacer(),
              pw.Divider(color: borderColor),
              pw.Center(
                child: pw.Text(
                  'Thank you for visiting Nailaura - The Nailart Studio!',
                  style: pw.TextStyle(fontSize: 10, color: darkGoldColor, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'Website: https://nailauraofficial.com | Contact: +91 8281791180',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _downloadPdf() async {
    final pdfBytes = await _generatePdfBytes();
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Nailaura_Invoice_$invoiceNumber.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                children: [
                  // 1. Main Store Header & Logo
                  _buildHeaderCard(),
                  const SizedBox(height: 16),

                  // 3. Experience Rating Survey Widget (Zudio Style)
                  _buildExperienceSurveyCard(),
                  const SizedBox(height: 16),

                  // 4. Main Invoice Receipt Card
                  _buildInvoiceCard(),
                  const SizedBox(height: 16),

                  // 5. Terms & Policy Notes
                  _buildTermsCard(),
                  const SizedBox(height: 20),

                  // 6. Action Buttons Bar
                  _buildActionButtons(isMobile),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171719),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  AppConstants.logoIcon,
                  height: 46,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppConstants.logoTextGold,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kulathoor, Trivandrum - 695583',
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              final uri = Uri.parse('https://nailauraofficial.com');
              if (await canLaunchUrl(uri)) launchUrl(uri);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(
                    'Store Details',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.primaryGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, color: AppTheme.primaryGold, size: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSurveyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171719),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            "Tell us about your overall experience",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (_ratingSubmitted)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, color: AppTheme.primaryGold, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Thank you for rating your Nailaura experience! 💖",
                    style: GoogleFonts.montserrat(
                      color: AppTheme.primaryGold,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmileyOption(0, "😄", "Most Likely", Colors.greenAccent),
                _buildSmileyOption(1, "😐", "Probably", Colors.amberAccent),
                _buildSmileyOption(2, "🙁", "Least Likely", Colors.orangeAccent),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSmileyOption(int index, String emoji, String label, Color accent) {
    final isSelected = _selectedRating == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRating = index;
          _ratingSubmitted = true;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: isSelected ? accent : Colors.white.withValues(alpha: 0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 26),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: isSelected ? accent : Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Studio Title
          Center(
            child: Column(
              children: [
                Text(
                  "Nailaura - The Nailart Studio",
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Kulathoor, Trivandrum - 695583",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Ph: +91 8281791180",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDashedLine(),
          const SizedBox(height: 12),

          // INVOICE RECEIPT Header
          Center(
            child: Text(
              "INVOICE RECEIPT",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildDashedLine(),
          const SizedBox(height: 16),

          // Invoice Meta Grid
          _buildMetaRow("INVOICE NO:", invoiceNumber, "DATE:", dateStr),
          const SizedBox(height: 6),
          _buildMetaRow("COUNTER:", "POS-01", "CASHIER:", "ADMIN"),
          const SizedBox(height: 6),
          _buildMetaRow("CUSTOMER NAME:", customerName, "MOBILE NO:", phone),
          const SizedBox(height: 16),
          _buildDashedLine(),
          const SizedBox(height: 16),

          // Items List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Item Description",
                  style: GoogleFonts.montserrat(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Qty",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Net Amount",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.montserrat(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDashedLine(),
          const SizedBox(height: 10),

          // Item Rows
          ...itemsList.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item['name'] ?? '',
                      style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "1",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "₹${item['price']}",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 12),
          _buildDashedLine(),
          const SizedBox(height: 16),

          // Financial Summary (No Tax Fields)
          _buildSummaryRow("Subtotal:", "₹${totalAmount.toStringAsFixed(2)}"),
          const SizedBox(height: 8),
          _buildDashedLine(),
          const SizedBox(height: 12),

          // Total Invoice Amount & Payment Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TOTAL AMOUNT",
                    style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                  ),
                  Text(
                    "₹${totalAmount.toStringAsFixed(2)}",
                    style: GoogleFonts.montserrat(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2E7D32), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "PAYMENT PAID",
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF2E7D32),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildDashedLine(),
          const SizedBox(height: 20),

          // Barcode Display
          Center(
            child: Column(
              children: [
                _buildBarcodeWidget(invoiceNumber),
                const SizedBox(height: 6),
                Text(
                  "-$invoiceNumber-",
                  style: GoogleFonts.orbitron(
                    color: Colors.black54,
                    fontSize: 12,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Need help? Reach us at +91 8281791180",
                  style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "$label1 ", style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w600)),
                TextSpan(text: value1, style: GoogleFonts.montserrat(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(text: "$label2 ", style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w600)),
                TextSpan(text: value2, style: GoogleFonts.montserrat(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500)),
        Text(value, style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.maxWidth;
        const dashWidth = 6.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildBarcodeWidget(String code) {
    return Container(
      height: 48,
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(35, (index) {
          final isThick = index % 3 == 0 || index % 7 == 0;
          return Container(
            width: isThick ? 3.5 : 1.5,
            color: index % 5 == 4 ? Colors.transparent : Colors.black87,
          );
        }),
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171719),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined, color: AppTheme.primaryGold, size: 18),
              const SizedBox(width: 8),
              Text(
                "15-DAY SERVICE WARRANTY & POLICY",
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBulletPoint("We provide an exclusive 15-day service warranty on gel extensions and structured nail art."),
          _buildBulletPoint("Please retain this digital receipt for touch-ups or warranty inquiries within 15 days."),
          _buildBulletPoint("Services performed are non-refundable after service completion."),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(color: AppTheme.primaryGold.withValues(alpha: 0.8), fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _downloadPdf,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 4,
            ),
            icon: const Icon(Icons.download, size: 20),
            label: Text(
              "Download Bill (PDF)",
              style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final text = "Check out my Nailaura receipt: https://nailauraofficial.com/#/invoice?inv=$invoiceNumber&name=${Uri.encodeComponent(customerName)}&phone=$phone&date=${Uri.encodeComponent(dateStr)}&total=$totalStr&items=${Uri.encodeComponent(rawItems)}";
                  final url = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(text)}");
                  if (await canLaunchUrl(url)) launchUrl(url);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.share, size: 18),
                label: Text("Share Link", style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://nailauraofficial.com');
                  if (await canLaunchUrl(uri)) launchUrl(uri);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGold,
                  side: BorderSide(color: AppTheme.primaryGold.withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.language, size: 18),
                label: Text("Main Website", style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

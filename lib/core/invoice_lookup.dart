import 'dart:convert';
import 'package:http/http.dart' as http;

/// Loads a saved invoice from the billing app's Firestore by its random ID,
/// using the public REST API (security rules allow reading a single invoice
/// by ID only). Returns the same keys the older link format used, plus
/// subtotal / discount / payment.
class InvoiceLookup {
  static const _project = 'nailaurabilling';
  // Firebase web API key: a public project identifier, not a secret.
  static const _apiKey = 'AIzaSyAhNKDXnFJOEqwBHM5ns3Rn4HrsM6bh1Qc';

  static Future<Map<String, String>> fetch(String id) async {
    if (!RegExp(r'^[A-Za-z0-9]{10,40}$').hasMatch(id)) {
      throw const FormatException('Invalid invoice link');
    }
    final uri = Uri.https(
      'firestore.googleapis.com',
      '/v1/projects/$_project/databases/(default)/documents/invoices/$id',
      {'key': _apiKey},
    );
    final res = await http.get(uri);
    if (res.statusCode == 404) throw const FormatException('Invoice not found');
    if (res.statusCode != 200) throw Exception('Could not load invoice (${res.statusCode})');

    final fields = (jsonDecode(res.body)['fields'] ?? {}) as Map<String, dynamic>;
    final items = ((fields['items']?['arrayValue']?['values'] as List?) ?? [])
        .map((v) => (v['mapValue']?['fields'] ?? {}) as Map<String, dynamic>)
        .map((f) => '${_str(f['name'])}:${_num(f['price']).toStringAsFixed(2)}')
        .join('|');
    final ts = DateTime.tryParse(_str(fields['timestamp']))?.toLocal() ?? DateTime.now();
    final total = _num(fields['totalAmount']);

    return {
      'inv': _str(fields['invoiceNumber']),
      'name': _str(fields['customerName']),
      'phone': _str(fields['phone']),
      'date': '${ts.day.toString().padLeft(2, '0')}/${ts.month.toString().padLeft(2, '0')}/${ts.year}',
      'items': items,
      'total': total.toStringAsFixed(2),
      'subtotal': (fields.containsKey('subtotal') ? _num(fields['subtotal']) : total).toStringAsFixed(2),
      'discount': _num(fields['discount']).toStringAsFixed(2),
      'payment': _str(fields['paymentMethod']),
      ..._loyalty(fields['loyalty']),
    };
  }

  /// Aura card state saved on the invoice (empty for older invoices).
  static Map<String, String> _loyalty(dynamic v) {
    final f = v?['mapValue']?['fields'];
    if (f is! Map) return const {};
    return {
      'loyaltyCard': _num(f['card']).toInt().toString(),
      'loyaltyFilled': _num(f['filled']).toInt().toString(),
    };
  }

  static String _str(dynamic v) =>
      (v?['stringValue'] ?? v?['timestampValue'] ?? '') as String;

  static double _num(dynamic v) {
    if (v == null) return 0;
    final raw = v['doubleValue'] ?? v['integerValue'];
    return raw is num ? raw.toDouble() : double.tryParse('$raw') ?? 0;
  }
}

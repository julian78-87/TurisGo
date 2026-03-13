import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/Pantallas/Sub/Coments.dart';

class RatingBadge extends StatelessWidget {
  final dynamic serviceId;
  final Color textColor;

  const RatingBadge({
    super.key,
    required this.serviceId,
    required this.textColor,
  });

  Future<Map<String, dynamic>> _getRatingData() async {
    try {
      final response = await Supabase.instance.client
          .from('reviews')
          .select('rating')
          .eq('service_id', serviceId);

      if ((response as List).isEmpty) return {'avg': 0.0, 'count': 0};
      final data = response;
      double sum = data.fold(0, (prev, curr) => prev + (curr['rating'] as num));
      return {'avg': sum / data.length, 'count': data.length};
    } catch (e) {
      return {'avg': 0.0, 'count': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getRatingData(),
      builder: (context, snapshot) {
        final double avg = snapshot.data?['avg'] ?? 0.0;
        final int count = snapshot.data?['count'] ?? 0;
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RatingPage(serviceId: serviceId.toString()),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: textColor.withOpacity(0.05), blurRadius: 20),
              ],
            ),
            child: Row(
              children: [
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < avg.floor()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  avg.toStringAsFixed(1),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  " ($count opiniones)",
                  style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: textColor.withOpacity(0.3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

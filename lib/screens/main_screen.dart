import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Slot 1
  String _slot1Status = 'Loading...';
  String _slot1Plate = 'None';

  // Slot 2
  String _slot2Status = 'Loading...';
  String _slot2Plate = 'None';

  late final Stream<DatabaseEvent> _slot1Stream;
  late final Stream<DatabaseEvent> _slot2Stream;

  @override
  void initState() {
    super.initState();
    _slot1Stream = _db.child('Parking_Slot_1').onValue;
    _slot2Stream = _db.child('Parking_Slot_2').onValue;
  }

  bool get _slot1Occupied =>
      _slot1Status.toLowerCase() == 'occupied';

  bool get _slot2Occupied =>
      _slot2Status.toLowerCase() == 'occupied';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A56DB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Smart Parking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.15),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header label
              const Text(
                'Parking Slots',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Live Availability',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 28),

              // Slot 1
              StreamBuilder<DatabaseEvent>(
                stream: _slot1Stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map,
                    );
                    _slot1Status = (data['status'] ?? 'Unknown').toString();
                    _slot1Plate = (data['current_plate'] ?? 'None').toString();
                  }
                  return _SlotCard(
                    slotNumber: 1,
                    status: _slot1Status,
                    plate: _slot1Plate,
                    isOccupied: _slot1Occupied,
                    isLoading: snapshot.connectionState == ConnectionState.waiting,
                  );
                },
              ),

              const SizedBox(height: 16),

              // Slot 2
              StreamBuilder<DatabaseEvent>(
                stream: _slot2Stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map,
                    );
                    _slot2Status = (data['status'] ?? 'Unknown').toString();
                    _slot2Plate = (data['current_plate'] ?? 'None').toString();
                  }
                  return _SlotCard(
                    slotNumber: 2,
                    status: _slot2Status,
                    plate: _slot2Plate,
                    isOccupied: _slot2Occupied,
                    isLoading: snapshot.connectionState == ConnectionState.waiting,
                  );
                },
              ),

              const Spacer(),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: const Color(0xFF16A34A), label: 'Available'),
                  const SizedBox(width: 24),
                  _LegendDot(color: const Color(0xFFDC2626), label: 'Occupied'),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Slot Card Widget
// ---------------------------------------------------------------------------

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slotNumber,
    required this.status,
    required this.plate,
    required this.isOccupied,
    required this.isLoading,
  });

  final int slotNumber;
  final String status;
  final String plate;
  final bool isOccupied;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
    isLoading ? const Color(0xFF9CA3AF) :
    isOccupied ? const Color(0xFFDC2626) : const Color(0xFF16A34A);

    final Color statusBg =
    isLoading ? const Color(0xFFF3F4F6) :
    isOccupied ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4);

    final String statusLabel =
    isLoading ? 'Loading...' : isOccupied ? 'Occupied' : 'Available';

    final bool showPlate = isOccupied && plate != 'None' && plate.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Slot icon / number
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1A56DB).withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                'P$slotNumber',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A56DB),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Slot $slotNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                if (showPlate) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car_rounded,
                        size: 13,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        plate,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    isOccupied ? 'Plate not detected' : 'No vehicle',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Status badge
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Legend dot
// ---------------------------------------------------------------------------

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
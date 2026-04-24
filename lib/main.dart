import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CompanyProfileApp());
}

// 1. Model Data untuk menampung isi config.json
class CompanyConfig {
  final String companyName;
  final String address;

  CompanyConfig({required this.companyName, required this.address});

  factory CompanyConfig.fromJson(Map<String, dynamic> json) {
    return CompanyConfig(
      companyName: json['company_name'] ?? 'Loading Name...',
      address: json['address'] ?? 'Loading Address...',
    );
  }
}

class CompanyProfileApp extends StatelessWidget {
  const CompanyProfileApp({super.key});

  // 2. Fungsi untuk membaca file JSON dari folder assets
  Future<CompanyConfig> _loadConfig() async {
    try {
      final String response = await rootBundle.loadString('assets/config.json');
      final data = await json.decode(response);
      return CompanyConfig.fromJson(data);
    } catch (e) {
      // Fallback jika file tidak ditemukan saat development
      return CompanyConfig(companyName: "Arunika Consulting", address: "Jakarta");
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0E3B43);
    const secondary = Color(0xFFC48A3A);
    const surface = Color(0xFFF5F1EA);

    // 3. Gunakan FutureBuilder di tingkat paling atas untuk memuat data sekali saja
    return FutureBuilder<CompanyConfig>(
      future: _loadConfig(),
      builder: (context, snapshot) {
        final config = snapshot.data;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: config?.companyName ?? 'Company Profile',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              brightness: Brightness.light,
              primary: primary,
              secondary: secondary,
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: surface,
          ),
          // Melewatkan data config ke halaman utama
          home: CompanyProfilePage(config: config),
        );
      },
    );
  }
}

class CompanyProfilePage extends StatelessWidget {
  final CompanyConfig? config;
  const CompanyProfilePage({super.key, this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF5F1EA), Color(0xFFF4F7F5), Color(0xFFECE7DE)],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _TopBar(isMobile: isMobile, companyName: config?.companyName),
                  _Section(child: _HeroSection(isMobile: isMobile, companyName: config?.companyName)),
                  _Section(child: _MetricsSection(isMobile: isMobile)),
                  _Section(child: _AboutSection(isMobile: isMobile, companyName: config?.companyName)),
                  _Section(child: _ContactSection(isMobile: isMobile, address: config?.address)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- WIDGET KOMPONEN YANG SEKARANG DINAMIS ---

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isMobile, this.companyName});
  final bool isMobile;
  final String? companyName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, isMobile ? 24 : 32, 24, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.78),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE6DDD0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.apartment_rounded, color: Color(0xFF0E3B43), size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    companyName ?? 'Arunika Consulting', // OTOMATIS
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isMobile, this.companyName});
  final bool isMobile;
  final String? companyName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 28 : 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: const Color(0xFF0E3B43),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang di ${companyName ?? 'Perusahaan Kami'}', // OTOMATIS
            style: TextStyle(
              color: Colors.white, 
              fontSize: isMobile ? 32 : 48, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Kami hadir memberikan solusi terbaik untuk kebutuhan bisnis Anda dengan integritas dan profesionalisme.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.isMobile, this.companyName});
  final bool isMobile;
  final String? companyName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tentang ${companyName ?? 'Kami'}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Kami adalah mitra strategis yang berfokus pada pertumbuhan jangka panjang. Setiap solusi yang kami berikan didasarkan pada data dan eksekusi yang nyata."),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.isMobile, this.address});
  final bool isMobile;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE6DDD0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: Color(0xFFC48A3A)),
          const SizedBox(width: 12),
          Text("Lokasi Kami: ${address ?? 'Jakarta'}", style: const TextStyle(fontWeight: FontWeight.w600)), // OTOMATIS
        ],
      ),
    );
  }
}

// Helper Widgets
class _Section extends StatelessWidget {
  final Widget child;
  const _Section({required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1180), child: child)),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.isMobile});
  final bool isMobile;
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _Metric(val: "100+", label: "Klien"),
        _Metric(val: "10+", label: "Tahun"),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final String val, label;
  const _Metric({required this.val, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(val, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0E3B43))),
      Text(label),
    ]);
  }
}

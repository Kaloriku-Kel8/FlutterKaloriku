import 'dart:convert';
import 'dart:io';
import 'package:kaloriku/model/dataUser.dart';
import 'package:http/http.dart' as http;

enum JenisKelamin { laki, perempuan }

enum TingkatAktivitas {
  rendah,
  sedang,
  tinggi,
}

enum Tujuan {
  menambah,
  menurunkan,
  mempertahankan,
}

enum BMIKategori {
  kurus,
  normal,
  gemuk,
  obesitas,
}

class DataUser {
  String? userUuid;
  String? nama;
  int? umur;
  DateTime? tanggalLahir;
  JenisKelamin? jenisKelamin;
  double? beratBadan;
  double? tinggiBadan;
  TingkatAktivitas? tingkatAktivitas;
  Tujuan? tujuan;
  double? targetKalori;
  double? bmi;
  BMIKategori? bmiKategori;

  DataUser({
    this.userUuid,
    this.nama,
    this.umur,
    this.tanggalLahir,
    this.jenisKelamin,
    this.beratBadan,
    this.tinggiBadan,
    this.tingkatAktivitas,
    this.tujuan,
    this.targetKalori,
    this.bmi,
    this.bmiKategori,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      userUuid: json['user_uuid'],
      nama: json['nama'],
      umur: json['umur'] != null ? int.tryParse(json['umur'].toString()) : null,
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse(json['tanggal_lahir'])
          : null,
      jenisKelamin: json['jenis_kelamin'] != null
          ? JenisKelamin.values.firstWhere(
              (e) => e.toString().split('.').last == json['jenis_kelamin'],
              orElse: () => JenisKelamin.laki,
            )
          : null,
      beratBadan: json['berat_badan'] != null
          ? double.tryParse(json['berat_badan'].toString())
          : null,
      tinggiBadan: json['tinggi_badan'] != null
          ? double.tryParse(json['tinggi_badan'].toString())
          : null,
      tingkatAktivitas: json['tingkat_aktivitas'] != null
          ? TingkatAktivitas.values.firstWhere(
              (e) => e.toString().split('.').last == json['tingkat_aktivitas'],
              orElse: () => TingkatAktivitas.rendah,
            )
          : null,
      tujuan: json['tujuan'] != null
          ? Tujuan.values.firstWhere(
              (e) => e.toString().split('.').last == json['tujuan'],
              orElse: () => Tujuan.menambah,
            )
          : null,
      targetKalori: json['target_kalori'] != null
          ? double.tryParse(json['target_kalori'].toString())
          : null,
      bmi: json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null,
      bmiKategori: json['bmi_kategori'] != null
          ? BMIKategori.values.firstWhere(
              (e) => e.toString().split('.').last == json['bmi_kategori'],
              orElse: () => BMIKategori.normal,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_uuid': userUuid,
      'nama': nama,
      'umur': umur,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'jenis_kelamin': jenisKelamin?.toString().split('.').last,
      'berat_badan': beratBadan,
      'tinggi_badan': tinggiBadan,
      'tingkat_aktivitas': tingkatAktivitas?.toString().split('.').last,
      'tujuan': tujuan?.toString().split('.').last,
      'target_kalori': targetKalori,
      'bmi': bmi,
      'bmi_kategori': bmiKategori?.toString().split('.').last,
    };
  }
}

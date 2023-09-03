// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:admin_ecommerce_app/extensions/order_status_extensions.dart';
import 'package:admin_ecommerce_app/extensions/string_extensions.dart';
import 'package:admin_ecommerce_app/models/order_status.dart';

class TrackingStatus {
  final String id;
  final OrderStatus status;
  final String? shipperName;
  final String? shipperPhoneNumber;
  final String? cancellationReason;
  final String? currentLocation;
  final String? transferDestination;
  final Timestamp createAt;
  TrackingStatus({
    required this.id,
    required this.status,
    this.shipperName,
    this.shipperPhoneNumber,
    this.cancellationReason,
    this.currentLocation,
    this.transferDestination,
    required this.createAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status.toOrderStatusString(),
      'shipperName': shipperName,
      'shipperPhoneNumber': shipperPhoneNumber,
      'cancellationReason': cancellationReason,
      'currentLocation': currentLocation,
      'transferDestination': transferDestination,
      'createAt': createAt,
    };
  }

  factory TrackingStatus.fromMap(Map<String, dynamic> map) {
    return TrackingStatus(
      id: map['id'] as String,
      status: (map['status'] as String).toOrderStatus(),
      shipperName:
          map['shipperName'] != null ? map['shipperName'] as String : null,
      shipperPhoneNumber: map['shipperPhoneNumber'] != null
          ? map['shipperPhoneNumber'] as String
          : null,
      cancellationReason: map['cancellationReason'] != null
          ? map['cancellationReason'] as String
          : null,
      currentLocation: map['currentLocation'] != null
          ? map['currentLocation'] as String
          : null,
      transferDestination: map['transferDestination'] != null
          ? map['transferDestination'] as String
          : null,
      createAt: map['createAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackingStatus.fromJson(String source) =>
      TrackingStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  TrackingStatus copyWith({
    String? id,
    OrderStatus? status,
    String? shipperName,
    String? shipperPhoneNumber,
    String? cancellationReason,
    String? currentLocation,
    String? transferDestination,
    Timestamp? createAt,
  }) {
    return TrackingStatus(
      id: id ?? this.id,
      status: status ?? this.status,
      shipperName: shipperName ?? this.shipperName,
      shipperPhoneNumber: shipperPhoneNumber ?? this.shipperPhoneNumber,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      currentLocation: currentLocation ?? this.currentLocation,
      transferDestination: transferDestination ?? this.transferDestination,
      createAt: createAt ?? this.createAt,
    );
  }
}

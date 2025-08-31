class Stop {
  final String stopname;
  final double latitude;
  final double longitude;
  final int timedifference;

  Stop({
    required this.stopname,
    required this.latitude,
    required this.longitude,
    required this.timedifference,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      stopname: json['stopname'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timedifference: json['timedifference'],
    );
  }
}

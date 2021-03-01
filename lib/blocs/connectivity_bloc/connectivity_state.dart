part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  final bool connected;

  ConnectivityState({@required this.connected});

  @override
  List<Object> get props => [connected];
}

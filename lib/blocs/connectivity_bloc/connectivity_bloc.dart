import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription<ConnectivityResult> _subscription;

  ConnectivityBloc() : super(ConnectivityState(connected: false)) {
    /// The callback to `listen` is expected to of type [void]
    _subscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      this.add(ConnectivityStatusChanged(connectivityResult));
    });
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is ConnectivityStatusChanged) {
      bool connected = event.result != ConnectivityResult.none;
      yield ConnectivityState(connected: connected);
    }
  }
}

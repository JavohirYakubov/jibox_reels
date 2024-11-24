import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BaseState extends Equatable {}

class InitialState extends BaseState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class LoadedItems extends BaseState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class ShowErrorMessage extends BaseState {
  final String message;

  ShowErrorMessage(this.message);

  @override
  List<Object?> get props => [UniqueKey()];
}

class ShowInfoMessage extends BaseState {
  final String message;

  ShowInfoMessage(this.message);

  @override
  List<Object?> get props => [UniqueKey()];
}

class ShowLoadingState extends BaseState {
  final bool show;
  ShowLoadingState(this.show);

  @override
  List<Object?> get props => [UniqueKey()];
}

class ShowSubmitLoadingState extends BaseState {
  final bool show;
  ShowSubmitLoadingState(this.show);

  @override
  List<Object?> get props => [UniqueKey()];
}
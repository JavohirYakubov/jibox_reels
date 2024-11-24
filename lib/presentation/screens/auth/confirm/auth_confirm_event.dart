abstract class AuthConfirmEvent {}

class InitEvent extends AuthConfirmEvent {}
class ChangePinEvent extends AuthConfirmEvent {}
class SubmitEvent extends AuthConfirmEvent {
  final String phone;
  SubmitEvent(this.phone);
}
abstract class AuthEvent {}

class InitEvent extends AuthEvent {}
class ChangePhoneEvent extends AuthEvent {}
class SubmitEvent extends AuthEvent {}
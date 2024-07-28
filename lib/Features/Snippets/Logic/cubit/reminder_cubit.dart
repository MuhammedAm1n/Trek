import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_diary/Features/Snippets/Data/RemindersRepo.dart';

part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final Remindersrepo _remindersrepo;
  ReminderCubit(this._remindersrepo) : super(ReminderInitial());

  void addReminder(String message) {
    _remindersrepo.addReminder(message);
  }

  Stream<QuerySnapshot> getReminder() {
    final reuslt = _remindersrepo.getReminder();

    return reuslt;
  }
}

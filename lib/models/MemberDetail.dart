import 'memberModel.dart';

class MemberDetail {
  String teamName = '';
  String type;
  List<member> members = [];
  MemberDetail(this.teamName, this.members, this.type);
}

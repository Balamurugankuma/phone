import 'package:untitled19/Repository.dart';
import 'package:untitled19/models/contact.dart';

class User_service {
  late Repository _repository;
  User_service() {
    _repository = Repository();
  }
  Saveuser(contact data) async {
    return await _repository.insertdata('contact', data.tomap());
  }

  readuser() async {
    return await _repository.read_data('contact');
  }

  updateuser(contact data) async {
    return await _repository.update_data('contact', data.tomap());
  }

  deleteuser(id) async {
    return await _repository.delete_data('contact', id);
  }

  Serachuser(String keyword) async {
    return await _repository.search_data('contact', keyword);
  }
}

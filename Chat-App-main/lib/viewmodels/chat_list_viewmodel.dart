import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ChatListViewModel extends ChangeNotifier {
  UserModel? currentUser;
  bool isLoading = true;
  String _searchQuery = '';
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

  ChatListViewModel() {
    _loadCurrentUser();
    _loadUsers();
  }

  String get searchQuery => _searchQuery;
  List<UserModel> get filteredUsers => _filteredUsers;

  Future<void> _loadCurrentUser() async {
    // This would be replaced with a real user fetch from Firebase
    isLoading = true;
    notifyListeners();
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUsers() async {
    // Initialize with dummy users (in real app, this would come from Firebase)
    _allUsers = _getDummyUsers();
    _filteredUsers = List.from(_allUsers);
    notifyListeners();
  }

  void searchUsers(String query) {
    _searchQuery = query.toLowerCase();
    
    if (_searchQuery.isEmpty) {
      _filteredUsers = List.from(_allUsers);
    } else {
      _filteredUsers = _allUsers.where((user) {
        final name = user.displayName?.toLowerCase() ?? '';
        final email = user.email.toLowerCase();
        return name.contains(_searchQuery) || email.contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredUsers = List.from(_allUsers);
    notifyListeners();
  }

  List<UserModel> _getDummyUsers() {
    return [
      UserModel(
        uid: '1',
        email: 'haris@example.com',
        displayName: 'Haris Nisar',
        isOnline: true,
      ),
      UserModel(
        uid: '2',
        email: 'hayat@example.com',
        displayName: 'Hayat Ishfaq',
        isOnline: false,
      ),
      UserModel(
        uid: '3',
        email: 'nasir@example.com',
        displayName: 'Nasir Ali',
        isOnline: true,
      ),
      UserModel(
        uid: '4',
        email: 'hamza@example.com',
        displayName: 'Hamza Khan',
        isOnline: false,
      ),
      UserModel(
        uid: '5',
        email: 'abdul@example.com',
        displayName: 'Abdul Mannan',
        isOnline: true,
      ),
    ];
  }
}

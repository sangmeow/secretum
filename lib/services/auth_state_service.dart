/// In-memory authentication state service
/// This service manages authentication state in volatile memory
/// The state is reset when the app is closed or terminated
class AuthStateService {
  // Private constructor for singleton pattern
  AuthStateService._internal();

  // Singleton instance
  static final AuthStateService _instance = AuthStateService._internal();

  // Factory constructor returns the singleton instance
  factory AuthStateService() => _instance;

  // Volatile authentication flag (resets when app closes)
  bool _isAuthenticated = false;

  // Timestamp of last authentication
  DateTime? _lastAuthTime;

  // Optional: Auto-lock timeout in minutes (null = no timeout)
  int? _autoLockTimeoutMinutes;

  /// Check if user is authenticated
  bool get isAuthenticated {
    // If auto-lock is enabled, check if session expired
    if (_autoLockTimeoutMinutes != null && _lastAuthTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_lastAuthTime!);

      if (difference.inMinutes >= _autoLockTimeoutMinutes!) {
        // Session expired, reset authentication
        logout();
        return false;
      }
    }

    return _isAuthenticated;
  }

  /// Get last authentication time
  DateTime? get lastAuthTime => _lastAuthTime;

  /// Set user as authenticated
  void authenticate() {
    _isAuthenticated = true;
    _lastAuthTime = DateTime.now();
  }

  /// Logout user (clear authentication flag)
  void logout() {
    _isAuthenticated = false;
    _lastAuthTime = null;
  }

  /// Update last activity time (for auto-lock timeout)
  void updateActivity() {
    if (_isAuthenticated) {
      _lastAuthTime = DateTime.now();
    }
  }

  /// Set auto-lock timeout (in minutes, null to disable)
  void setAutoLockTimeout(int? minutes) {
    _autoLockTimeoutMinutes = minutes;
  }

  /// Get current auto-lock timeout
  int? get autoLockTimeout => _autoLockTimeoutMinutes;

  /// Reset all state (for testing or logout)
  void reset() {
    _isAuthenticated = false;
    _lastAuthTime = null;
  }

  /// Get session duration (time since authentication)
  Duration? getSessionDuration() {
    if (_lastAuthTime == null) {
      return null;
    }
    return DateTime.now().difference(_lastAuthTime!);
  }

  /// Check if session is about to expire (within threshold)
  bool isSessionNearExpiry({int thresholdMinutes = 5}) {
    if (_autoLockTimeoutMinutes == null || _lastAuthTime == null || !_isAuthenticated) {
      return false;
    }

    final now = DateTime.now();
    final difference = now.difference(_lastAuthTime!);
    final remainingMinutes = _autoLockTimeoutMinutes! - difference.inMinutes;

    return remainingMinutes <= thresholdMinutes && remainingMinutes > 0;
  }
}

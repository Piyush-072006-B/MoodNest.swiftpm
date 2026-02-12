import Foundation

/// Manages onboarding state using UserDefaults
final class OnboardingManager {
    private static let hasCompletedKey = "hasCompletedOnboarding"
    
    /// Check if user has completed onboarding
    static func hasCompletedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: hasCompletedKey)
    }
    
    /// Mark onboarding as complete
    static func markOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: hasCompletedKey)
        print("[OnboardingManager] Onboarding marked as complete")
    }
    
    /// Reset onboarding (for testing purposes)
    static func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: hasCompletedKey)
        print("[OnboardingManager] Onboarding reset")
    }
}

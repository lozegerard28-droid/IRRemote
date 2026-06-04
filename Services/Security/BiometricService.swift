import Foundation
import LocalAuthentication

class BiometricService: BiometricAuthenticatable {
    static let shared = BiometricService()
    private let context = LAContext()
    
    var isAvailable: Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    var biometryType: LABiometryType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    func authenticate(reason: String) async throws -> Bool {
        guard isAvailable else { throw AppError.biometricUnavailable }
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                  localizedReason: reason) { success, error in
                if success { continuation.resume(returning: true) }
                else { continuation.resume(throwing: error ?? AppError.authenticationFailed) }
            }
        }
    }
}
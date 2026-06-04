import Foundation
import LocalAuthentication

class BiometricService: BiometricAuthenticatable {
    static let shared = BiometricService()

    var isAvailable: Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    var biometryType: LABiometryType {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }

    func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            throw AppError.biometricUnavailable
        }
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                  localizedReason: reason) { success, error in
                if success { continuation.resume(returning: true) }
                else { continuation.resume(throwing: error ?? AppError.authenticationFailed) }
            }
        }
    }
}

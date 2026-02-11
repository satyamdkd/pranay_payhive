// import UIKit
// import Flutter
// import GoogleMaps
//
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//
//     GMSServices.provideAPIKey("AIzaSyBV93sZuyUT9XwKbnVKWByrHE0V5VsYCg0")
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }


import UIKit
import Flutter
import GoogleMaps
import LocalAuthentication

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "native_biometric_auth"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GMSServices.provideAPIKey("AIzaSyBV93sZuyUT9XwKbnVKWByrHE0V5VsYCg0")

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: CHANNEL,
                                               binaryMessenger: controller.binaryMessenger)

        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) in

            switch call.method {
            case "authenticateWithBiometrics":
                self.authenticateWithBiometrics(result: result)
            case "canCheckBiometrics":
                self.canCheckBiometrics(result: result)
            case "getAvailableBiometrics":
                self.getAvailableBiometrics(result: result)
            case "isDeviceSupported":
                self.isDeviceSupported(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func authenticateWithBiometrics(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?

        // First check if any authentication is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            let errorMessage = self.getErrorMessage(from: error)
            result(FlutterError(code: "BIOMETRIC_NOT_AVAILABLE",
                              message: errorMessage,
                              details: nil))
            return
        }

        let reason = "Authenticate to access the app"

        // Use .deviceOwnerAuthentication to include passcode fallback
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
            DispatchQueue.main.async {
                if success {
                    result(true)
                } else {
                    let errorCode = self.getErrorCode(error: evaluateError as? LAError)
                    let errorMessage = self.getErrorMessage(from: evaluateError)
                    result(FlutterError(code: errorCode, message: errorMessage, details: nil))
                }
            }
        }
    }

    private func canCheckBiometrics(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?

        // Check specifically for biometric authentication
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        result(canEvaluate)
    }

    private func getAvailableBiometrics(result: @escaping FlutterResult) {
        let context = LAContext()
        var biometrics: [String] = []

        // Only check if biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID:
                biometrics.append("face")
            case .touchID:
                biometrics.append("fingerprint")
            case .opticID:
                biometrics.append("iris")
            case .none:
                // Device supports biometrics but type is unknown
                biometrics.append("unknown")
            @unknown default:
                biometrics.append("unknown")
            }
        }

        result(biometrics)
    }

    private func isDeviceSupported(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?

        // Check if any form of device authentication is supported
        let isSupported = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)

        if !isSupported && error != nil {
            // Log the error for debugging but still return the result
            print("Device authentication not supported: \(error!.localizedDescription)")
        }

        result(isSupported)
    }

    private func getErrorCode(error: LAError?) -> String {
        guard let error = error else { return "UNKNOWN_ERROR" }

        switch error.code {
        case .authenticationFailed:
            return "AUTHENTICATION_FAILED"
        case .userCancel:
            return "USER_CANCEL"
        case .userFallback:
            return "USER_FALLBACK"
        case .systemCancel:
            return "SYSTEM_CANCEL"
        case .passcodeNotSet:
            return "PASSCODE_NOT_SET"
        case .biometryNotAvailable:
            return "BIOMETRY_NOT_AVAILABLE"
        case .biometryNotEnrolled:
            return "BIOMETRY_NOT_ENROLLED"
        case .biometryLockout:
            return "BIOMETRY_LOCKOUT"
        case .invalidContext:
            return "INVALID_CONTEXT"
        case .notInteractive:
            return "NOT_INTERACTIVE"
        @unknown default:
            return "UNKNOWN_ERROR"
        }
    }

    private func getErrorMessage(from error: Error?) -> String {
        guard let error = error else { return "Unknown error occurred" }

        if let laError = error as? LAError {
            switch laError.code {
            case .authenticationFailed:
                return "Authentication failed. Please try again."
            case .userCancel:
                return "Authentication was cancelled by user."
            case .userFallback:
                return "User chose to use fallback authentication."
            case .systemCancel:
                return "Authentication was cancelled by system."
            case .passcodeNotSet:
                return "Device passcode is not set. Please set up a passcode in Settings."
            case .biometryNotAvailable:
                return "Biometric authentication is not available on this device."
            case .biometryNotEnrolled:
                return "No biometric data is enrolled. Please set up Face ID or Touch ID in Settings."
            case .biometryLockout:
                return "Biometric authentication is locked due to too many failed attempts. Please try again later or use device passcode."
            case .invalidContext:
                return "Authentication context is invalid."
            case .notInteractive:
                return "Authentication cannot be performed in current context."
            @unknown default:
                return error.localizedDescription
            }
        }

        return error.localizedDescription
    }
}

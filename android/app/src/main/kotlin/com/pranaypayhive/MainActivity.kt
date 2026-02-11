

package com.pranaypayhive;

import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executor

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "native_biometric_auth"
    private lateinit var channel: MethodChannel
    private lateinit var executor: Executor
    private lateinit var biometricPrompt: BiometricPrompt
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        executor = ContextCompat.getMainExecutor(this)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "authenticateWithBiometrics" -> {
                    authenticateWithBiometrics(result)
                }
                "canCheckBiometrics" -> {
                    canCheckBiometrics(result)
                }
                "getAvailableBiometrics" -> {
                    getAvailableBiometrics(result)
                }
                "isDeviceSupported" -> {
                    isDeviceSupported(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        setupBiometricPrompt()
    }

    private fun setupBiometricPrompt() {
        biometricPrompt = BiometricPrompt(this, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    super.onAuthenticationError(errorCode, errString)
                    val errorCodeString = when (errorCode) {
                        BiometricPrompt.ERROR_CANCELED -> "USER_CANCEL"
                        BiometricPrompt.ERROR_USER_CANCELED -> "USER_CANCEL"
                        BiometricPrompt.ERROR_NEGATIVE_BUTTON -> "USER_FALLBACK"
                        BiometricPrompt.ERROR_LOCKOUT -> "BIOMETRY_LOCKOUT"
                        BiometricPrompt.ERROR_LOCKOUT_PERMANENT -> "BIOMETRY_LOCKOUT_PERMANENT"
                        BiometricPrompt.ERROR_NO_BIOMETRICS -> "BIOMETRY_NOT_ENROLLED"
                        BiometricPrompt.ERROR_HW_NOT_PRESENT -> "BIOMETRIC_NOT_AVAILABLE"
                        BiometricPrompt.ERROR_HW_UNAVAILABLE -> "BIOMETRIC_NOT_AVAILABLE"
                        else -> "AUTHENTICATION_FAILED"
                    }
                    pendingResult?.error(errorCodeString, errString.toString(), null)
                    pendingResult = null
                }

                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    super.onAuthenticationSucceeded(result)
                    pendingResult?.success(true)
                    pendingResult = null
                }

                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
                    pendingResult?.error("AUTHENTICATION_FAILED", "Authentication failed", null)
                    pendingResult = null
                }
            })
    }

    private fun getAuthenticators(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // API 30+ supports BIOMETRIC_STRONG | DEVICE_CREDENTIAL
            BiometricManager.Authenticators.BIOMETRIC_STRONG or BiometricManager.Authenticators.DEVICE_CREDENTIAL
        } else {
            // API 29 and below - use only BIOMETRIC_STRONG
            BiometricManager.Authenticators.BIOMETRIC_STRONG
        }
    }

    private fun createPromptInfo(): BiometricPrompt.PromptInfo {
        val builder = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Biometric Authentication")
            .setSubtitle("Authenticate to access the app")

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // API 30+ - can use device credential
            builder
                .setDescription("Use your fingerprint, face, or device PIN/Pattern/Password")
                .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG or BiometricManager.Authenticators.DEVICE_CREDENTIAL)
                .build()
        } else {
            // API 29 and below - need negative button for fallback
            builder
                .setDescription("Use your fingerprint or face to authenticate")
                .setNegativeButtonText("Use PIN/Password")
                .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
                .build()
        }
    }

    private fun authenticateWithBiometrics(result: MethodChannel.Result) {
        val biometricManager = BiometricManager.from(this)
        val authenticators = getAuthenticators()

        // Check if we can authenticate
        when (biometricManager.canAuthenticate(authenticators)) {
            BiometricManager.BIOMETRIC_SUCCESS -> {
                // Biometrics available - proceed with authentication
                pendingResult = result
                val promptInfo = createPromptInfo()
                biometricPrompt.authenticate(promptInfo)
            }
            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> {
                // No biometric hardware - try device credential only on API 30+
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    tryDeviceCredentialOnly(result)
                } else {
                    result.error("BIOMETRIC_NOT_AVAILABLE", "No biometric hardware available", null)
                }
            }
            BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE -> {
                // Hardware unavailable - try device credential only on API 30+
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    tryDeviceCredentialOnly(result)
                } else {
                    result.error("BIOMETRIC_NOT_AVAILABLE", "Biometric hardware unavailable", null)
                }
            }
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> {
                // No biometrics enrolled - try device credential only on API 30+
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    tryDeviceCredentialOnly(result)
                } else {
                    result.error("BIOMETRY_NOT_ENROLLED", "No biometrics enrolled", null)
                }
            }
            else -> {
                result.error("BIOMETRIC_NOT_AVAILABLE", "Biometric authentication not available", null)
            }
        }
    }

    private fun tryDeviceCredentialOnly(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val biometricManager = BiometricManager.from(this)
            when (biometricManager.canAuthenticate(BiometricManager.Authenticators.DEVICE_CREDENTIAL)) {
                BiometricManager.BIOMETRIC_SUCCESS -> {
                    pendingResult = result
                    val promptInfo = BiometricPrompt.PromptInfo.Builder()
                        .setTitle("Device Authentication")
                        .setSubtitle("Authenticate using your device PIN, Pattern, or Password")
                        .setAllowedAuthenticators(BiometricManager.Authenticators.DEVICE_CREDENTIAL)
                        .build()
                    biometricPrompt.authenticate(promptInfo)
                }
                else -> {
                    result.error("DEVICE_CREDENTIAL_NOT_AVAILABLE", "Device credential not available", null)
                }
            }
        } else {
            result.error("BIOMETRIC_NOT_AVAILABLE", "Authentication not available on this device", null)
        }
    }

    private fun canCheckBiometrics(result: MethodChannel.Result) {
        val biometricManager = BiometricManager.from(this)
        val canAuthenticate = biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_WEAK)
        result.success(canAuthenticate == BiometricManager.BIOMETRIC_SUCCESS)
    }

    private fun getAvailableBiometrics(result: MethodChannel.Result) {
        val biometricManager = BiometricManager.from(this)
        val biometrics = mutableListOf<String>()

        when (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
            BiometricManager.BIOMETRIC_SUCCESS -> {
                biometrics.add("fingerprint")
            }
        }

        result.success(biometrics)
    }

    private fun isDeviceSupported(result: MethodChannel.Result) {
        val biometricManager = BiometricManager.from(this)

        // Check if any form of authentication is available
        val biometricSupported = biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_WEAK) in listOf(
            BiometricManager.BIOMETRIC_SUCCESS,
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED
        )

        val deviceCredentialSupported = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            biometricManager.canAuthenticate(BiometricManager.Authenticators.DEVICE_CREDENTIAL) == BiometricManager.BIOMETRIC_SUCCESS
        } else {
            // For API < 30, we assume device credential is available if the device is secured
            true // This is a reasonable assumption for most devices
        }

        result.success(biometricSupported || deviceCredentialSupported)
    }
}

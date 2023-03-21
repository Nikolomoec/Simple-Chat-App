//
//  AuthViewModel.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    static func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func getLoggedInUserId() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    static func logout() {
        try? Auth.auth().signOut()
    }
    
    static func getLoggedinUserPhone() -> String {
    
        return Auth.auth().currentUser?.phoneNumber ?? ""
        
    }
    
    static func sendPhoneNumber(phone: String, completion: @escaping (Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if error == nil {
                // Got the verificationID
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
            DispatchQueue.main.async {
                // Notify the UI
                completion(error)
            }
        }
    }
    static func verifyCode(code: String, completion: @escaping (Error?) -> Void) {
        // Get the verificationID from userDefaults
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        
        // Send the verID and user code to firebase
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        // Sign in the user
        Auth.auth().signIn(with: credential) { authResult, error in
            
            DispatchQueue.main.async {
                // Notify the UI
                // Always update UI on the main thread
                completion(error)
            }
        }
    }
}

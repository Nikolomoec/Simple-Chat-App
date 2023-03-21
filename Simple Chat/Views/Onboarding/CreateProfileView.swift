//
//  CreateProfileView.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import SwiftUI

struct CreateProfileView: View {
    
    @Binding var currentStep: Onboarding
    
    @State private var name = ""
    @State private var lastName = ""
    
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    
    @State private var source: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isSourceDialogShowing = false
    @State private var isSaveButtonDisabled = false
    
    var body: some View {
        VStack {
            
            VStack {
                
                Text("Setup your Profile")
                    .font(.verificationTitle)
                    .padding(.top, 40)
                
                Text("Just a few more detailes to get started")
                    .font(.verificationDesc_numberPlaceHolder)
                    .padding(.top, 24)
                    .padding(.horizontal, 39)
                    .padding(.bottom, 34)
            }
            .foregroundColor(Color("secondaryText"))
            .multilineTextAlignment(.center)
            
            Spacer()
            
            // Profile Image
            Button {
                isSourceDialogShowing.toggle()
            } label: {
                ZStack {
                    
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .foregroundColor(Color("TextField"))
                        
                        Image(systemName: "camera.fill")
                            .foregroundColor(.black)
                    }
                    Circle()
                        .stroke(Color("profileBorder"), lineWidth: 2)
                }
                .frame(width: 134, height: 134)
                
            }
            
            Spacer()
            
            TextField("Given Name", text: $name)
                .textFieldStyle(CustomTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CustomTextFieldStyle())
            
            Spacer()
            
            Button {
                
                isSaveButtonDisabled = true
                
                // Save The data
                DatabaseService().setUserProfile(firstName: name,
                                                 lastName: lastName,
                                                 image: selectedImage) { isSuscess in
                    if isSuscess {
                        currentStep = .contacts
                    } else {
                        
                    }
                    isSaveButtonDisabled = false
                }
            } label: {
                Text(isSaveButtonDisabled ? "Uploading" : "Save")
            }
            .buttonStyle(StartButtonStyle())
            .padding(.bottom, 77)
            .disabled(isSaveButtonDisabled)
        }
        .confirmationDialog("From where?", isPresented: $isSourceDialogShowing, actions: {
            
            // Set the source to image library
            // Show the image picker
            Button {
                
                self.source = .photoLibrary
                isPickerShowing = true
                
            } label: {
                Text("Photo Library")
            }
            
            // Set the source to camera
            // Show the image picker
            Button {
                
                self.source = .camera
                isPickerShowing = true
                
            } label: {
                Text("Take Photo")
            }
            
            
        })
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: self.source)
        }
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}

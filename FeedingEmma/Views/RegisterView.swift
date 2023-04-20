//
//  RegisterView.swift
//  FeedingEmma
//
//  Created by Justin on 4/11/23.
//

import SwiftUI

// MARK: Register View

struct RegisterView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio : String = ""
    @State var userBioLink: String = ""
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    @State var isLoading: Bool = false
    
    // MARK: UserDefault
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_UID") var userUID: String = ""

    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 10) {
            Text("Let's Register\nAccount")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Hello User, have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            
            // MARK: For smaller sizes
            ViewThatFits {
                
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                
                HelperView()
            }
            
            // MARK: Register Button
            HStack {
                Text("Already Have an account?")
                    .foregroundColor(.gray)
                
                Button("Login Now") {
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        // MARK: Display Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView () -> some View {
        VStack(spacing: 12) {
    
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            TextField("About You", text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            TextField("Bio Link (Optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            
            Button {
                registerUser()
            } label: {
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .disableWithOpacity(condition: userName == "" || password == "" || email == "")
            .padding(.top, 10)
        }

    }
    
    func registerUser() {
//        isLoading = true
//        
//        Task {
//            do {
//                try await Auth.auth().createUser(withEmail: email, password: password)
//                guard let userUID = Auth.auth().currentUser?.uid else { return }
//                
//                let user = User(userName: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: email)
//                
//                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
//                    
//                    if error == nil {
//                        print("Saved successfully")
//                        self.userUID = userUID
//                        self.logStatus = true
//                    }
//                    
//                })
//                
//            } catch {
//                await setError(error)
//            }
//        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false 
        })
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

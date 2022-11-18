//
//  LoginView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/17.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var emailInput = ""
    @State private var passwordInput = ""
    @State private var isLoginAlertPresented = false
    @FocusState private var typingEmail: Bool
    @FocusState private var typingPassword: Bool
    @AppStorage("studioID") private var studioID: String?
    
    @Binding var link: String
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Logo")
                .resizable()
                .frame(width: 151, height: 151)
                .padding(.bottom, 27)
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("환영합니다.")
                    HStack(spacing: 0) {
                        Text("번트 매니저")
                            .foregroundColor(.accent)
                        Text("에 로그인해주세요.")
                    }
                }
                .font(.system(size: 17, weight: .medium))
                Spacer()
            }
            .padding(.bottom, 27)
            
            VStack(spacing: 18) {
                LoginTextField(placeHolder: "이메일을 입력하세요.", isPassword: false, text: $emailInput, focused: $typingEmail)
                LoginTextField(placeHolder: "비밀번호를 입력하세요.", isPassword: true, text: $passwordInput, focused: $typingPassword)
            }
            .font(.system(size: 15))
            
            Rectangle()
                .frame(height: 131)
                .foregroundColor(Color(.systemBackground))
            
            Button {
                typingEmail = false
                typingPassword = false
                Task {
                    await login()
                }
            } label: {
                Text("로그인")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accent))
            }
            .padding(.bottom, 19)
        }
        .padding(.horizontal, 20)
        .onTapGesture {
            typingEmail = false
            typingPassword = false
        }
        .alert("이메일•비밀번호", isPresented: $isLoginAlertPresented) {
            Button("OK") {
                isLoginAlertPresented = false
            }
        } message: {
            Text("존재하지 않는 이메일 또는 비밀번호입니다.\n다시 시도하거나 기술지원팀에 연락하세요.")
        }

    }
    
    func login() async {
        do {
            let _ = try await FirebaseAuth.Auth.auth().signIn(withEmail: emailInput, password: passwordInput)
            studioID = try await DataService.shared.requestStudioBy(email: emailInput)?.ID
            if let id = studioID {
                link = await Constant.shared.fetchLink(id: id)
            }
        } catch {
            print(error)
            isLoginAlertPresented = true
        }
    }
}

struct LoginTextField: View {
    let placeHolder: String
    let isPassword: Bool
    @Binding var text: String
    var focused: FocusState<Bool>.Binding {
        didSet {
            print(focused.wrappedValue)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("ToastBackground"))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(focused.wrappedValue ? .white : Color("ToastBackground"), lineWidth: 1)
                        .frame(height: 50)
                }
                .frame(height: 50)
                .onTapGesture {
                    focused.projectedValue.wrappedValue = true
                }
            
            Group {
                if isPassword {
                    SecureField(placeHolder, text: $text)
                        
                } else {
                    TextField(placeHolder, text: $text)
                }
            }
            .textInputAutocapitalization(.never)
            .padding(15)
            .focused(focused)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(link: .constant(""))
    }
}

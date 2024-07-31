import SwiftUI

struct LoginView: View {
    @Binding var isPresented: Bool
    @Binding var isLoggedIn: Bool
    @State private var showSuccessAlert = false
    @State private var loginMethod: LoginMethod = .email  // 默认注册方式为邮箱
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var error: String?
    
    enum LoginMethod: String, CaseIterable, Identifiable {
        case email = "邮箱"
        case phone = "手机号"
        var id: String { self.rawValue }
    }
    
    private func SuccessAlert() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.8))
            Text("注册成功！")
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 50)
        .padding()
    }
    
    var body: some View {
        VStack {
            Picker("注册方式", selection: $loginMethod) {
                ForEach(LoginMethod.allCases) { method in
                    Text(method.rawValue).tag(method)
                }
            }
            .pickerStyle(.segmented)
            
            if loginMethod == .email {
                TextField("邮箱", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("密码", text: $password)
                    .textFieldStyle(.roundedBorder)
            } else {
                TextField("手机号", text: $phoneNumber)
                    .textFieldStyle(.roundedBorder)
                SecureField("密码", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            }
            
            HStack {
                Button("取消") {
                    isPresented = false
                }
                .buttonStyle(.bordered)
                
                Button("注册") {
                    if loginMethod == .email {
                        // 邮箱登录逻辑，在这里添加ODM代码，所需的邮件变量名为email
                    } else {
                        // 手机号登录逻辑，在这里添加ODM代码，所需的手机号变量名为phoneNumber
                    }
                    
                    showSuccessAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showSuccessAlert = false
                    }
                    isPresented = false
                    isLoggedIn = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text(""),
                message: Text("注册成功！"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


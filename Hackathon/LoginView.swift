import SwiftUI
import FirebaseAuth
//import FirebaseAnalytics

struct LoginView: View {
    @Binding var isPresented: Bool
    @Binding var isLoggedIn: Bool
    @State private var showSuccessAlert = false
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?

    private func SuccessAlert() -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green.opacity(0.8))
                Text("登录成功！")
                    .foregroundColor(.white)
            }
            .frame(width: 200, height: 50)
            .padding()
        }
    var body: some View {
        VStack {
            TextField("邮箱", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("密码", text: $password)
                .textFieldStyle(.roundedBorder)
            
           
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            }
            
            HStack {
                Button("取消") {
                    isPresented = false
                }
                .buttonStyle(.bordered)
                
                Button("登录") {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            self.error = error.localizedDescription
                        } else {
                            
                            //在这里添加ODM代码，所需的邮件变量名为email
                            //Analytics.initiateOnDeviceConversionMeasurement(emailAddress: email)
                            showSuccessAlert = true // 显示弹窗
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showSuccessAlert = false
                            }
                            isPresented = false
                            isLoggedIn = true
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text(""),
                message: Text("登录成功！"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

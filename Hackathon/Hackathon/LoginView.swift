import SwiftUI
import FirebaseAnalytics
import FirebaseAuth

struct LoginView: View {
    @Binding var isPresented: Bool // 控制弹窗是否显示的绑定变量
    @Binding var isLoggedIn: Bool // 添加 isLoggedIn 绑定变量
    @State private var showSuccessAlert = false // 添加状态变量
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
            
            HStack { // 水平布局，放置两个按钮
                Button("取消") {
                    isPresented = false // 关闭弹窗
                }
                .buttonStyle(.bordered)
                
                Button("登录") {
                    // 在这里处理登录逻辑
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            self.error = error.localizedDescription
                        } else {
                            Analytics.initiateOnDeviceConversionMeasurement(emailAddress: email)//删除
                            showSuccessAlert = true // 显示弹窗
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1 秒后隐藏弹窗
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
        .alert(isPresented: $showSuccessAlert) { // 使用 .alert 修饰器
            Alert( // 将 SuccessAlert() 包装成 Alert
                title: Text(""),
                message: Text("登录成功！"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

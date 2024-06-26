import SwiftUI
import AppTrackingTransparency
import AdSupport

struct ContentView: View {
    @State private var showLogin = false
    @State private var isLoggedIn = false // 添加 isLoggedIn 状态变量
    @State private var showPreview = false // 添加 showPreview 状态变量

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            if isLoggedIn || showPreview { // 根据 isLoggedIn 和 showPreview 的值来决定显示哪个视图
                MainView()
            } else {
                Text("欢迎使用 Hackathon App!")
                    .font(.title)

                Spacer()

                HStack { // 使用 HStack 水平排列两个按钮
                    Button("登录") {
                        showLogin = true
                    }
                    .buttonStyle(.borderedProminent)

                    Button("预览") { // 添加预览按钮
                        showPreview = true
                    }
                    .buttonStyle(.bordered)
                    
                }
            }

            Spacer()
        }
        .sheet(isPresented: $showLogin) {
            LoginView(isPresented: $showLogin, isLoggedIn: $isLoggedIn)
        }
        .onAppear { // 在视图出现时请求跟踪授权
            if #available(iOS 14, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // 延迟2秒
                    ATTrackingManager.requestTrackingAuthorization { status in
                        switch status {
                        case .authorized:
                            print("跟踪授权已授予")
                        case .denied:
                            print("跟踪授权被拒绝")
                        case .notDetermined:
                            print("用户尚未决定是否授予跟踪授权")
                        case .restricted:
                            print("跟踪授权受到限制")
                        @unknown default:
                            print("未知的授权状态")
                        }
                    }
                }
            }
        }
    }
}


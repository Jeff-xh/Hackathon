import SwiftUI
import AppTrackingTransparency

struct RecommendationView: View {
    @State private var showSuccessAlert = false // 添加状态变量，控制弹窗显示
    
    let products = [ // 模拟商品数据
        Product(name: "Notebook", price: 9.99, imageName: "notebook"),
        Product(name: "Red Tee", price: 19.99, imageName: "redtee"),
        Product(name: "Sweater", price: 29.99, imageName: "sweater")
    ]

    var body: some View {
        NavigationView {
            List(products) { product in
                HStack {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(product.name)
                            .font(.headline)

                        HStack { // 嵌套 HStack 来排列价格和按钮
                            Text("$\(product.price, specifier: "%.2f")")
                            Spacer() // 将按钮推到最右边
                            Button("购买") {
                                // 在这里处理购买逻辑
                                showSuccessAlert = true // 显示弹窗
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .navigationTitle("推荐榜")
            .listStyle(.plain)
            .background(Color(uiColor: .systemBackground))
            .alert("购买成功", isPresented: $showSuccessAlert) { // 添加弹窗
                Button("OK") {
                    showSuccessAlert = false // 点击 OK 后关闭弹窗
                }
            }
            .onAppear { // 在视图出现时请求跟踪授权
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        // 在这里处理授权结果
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

struct Product: Identifiable { // 商品数据结构
    let id = UUID()
    let name: String
    let price: Double
    let imageName: String
}

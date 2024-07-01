import SwiftUI
import FirebaseAnalytics // 导入 FirebaseAnalytics

struct SalesRankingView: View {
    @State private var showSuccessAlert = false

    let products = [
        Product_s(name: "Green Tee", price: 19.99, imageName: "greentee"),
        Product_s(name: "Black Hat", price: 9.99, imageName: "blackhat"),
        Product_s(name: "Pom Beanie", price: 29.99, imageName: "pombeanie")
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

                        HStack {
                            Text("$\(product.price, specifier: "%.2f")")
                            Spacer()
                            Button("购买") {
                                // 记录购买事件
                                Analytics.logEvent(AnalyticsEventPurchase, parameters: [
                                    AnalyticsParameterItemID: product.id.uuidString,
                                    AnalyticsParameterItemName: product.name,
                                    AnalyticsParameterPrice: product.price,
                                    AnalyticsParameterCurrency: "USD"
                                ])

                                showSuccessAlert = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .navigationTitle("销量榜")
            .listStyle(.plain)
            .background(Color(uiColor: .systemBackground))
            .alert("购买成功", isPresented: $showSuccessAlert) {
                Button("OK") {
                    showSuccessAlert = false
                }
            }
            .onAppear { // 在视图出现时记录事件
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "销量榜",
                    AnalyticsParameterScreenClass: "SalesRankingView"
                ])
            }
        }
    }
}

struct Product_s: Identifiable { // 商品数据结构
    let id = UUID()
    let name: String
    let price: Double
    let imageName: String
}

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            SalesRankingView()
                .tabItem {
                    Label("销量榜", systemImage: "list.star")
                }
            RecommendationView()
                .tabItem {
                    Label("推荐榜", systemImage: "star")
                }
        }
    }
}

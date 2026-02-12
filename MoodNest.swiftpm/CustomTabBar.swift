import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Home"
    case awareness = "Library"
    case calendar = "Calendar"
    case profile = "You"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .awareness: return "lightbulb.fill"
        case .calendar: return "calendar"
        case .profile: return "person.fill"
        }
    }
    
    var color: Color {
        // Teal/Aqua theme colors
        switch self {
        case .home: return .cyanBlue
        case .awareness: return .softAqua
        case .calendar: return .deepTeal
        case .profile: return .cyanBlue
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .frame(height: 60)
        .background(Color.lightSky)
        .overlay(
            Rectangle()
                .fill(Color.deepTeal.opacity(0.1))
                .frame(height: 0.5),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .deepTeal : .softAqua)
                
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .deepTeal : .softAqua)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.home))
    }
}

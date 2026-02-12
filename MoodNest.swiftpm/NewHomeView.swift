import SwiftUI

struct NewHomeView: View {
    @State private var selectedTab: TabItem = .home
    @State private var showCheckIn = false
    @State private var showSelfCare = false
    @State private var showGratitude = false
    @State private var showJournal = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content based on selected tab
            Group {
                switch selectedTab {
                case .home:
                    homeContent
                case .awareness:
                    ModernAwarenessView(selectedTab: $selectedTab)
                case .calendar:
                    ModernCalendarView(selectedTab: $selectedTab)
                case .profile:
                    ProfileView()
                }
            }
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showCheckIn) {
            ModernCheckInView()
        }
        .sheet(isPresented: $showSelfCare) {
            SelfCareView()
        }
        .sheet(isPresented: $showGratitude) {
            GratitudeView()
        }
        .sheet(isPresented: $showJournal) {
            JournalView()
        }
    }
    
    var homeContent: some View {
        ZStack {
            DecorativeBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header with gradient
                    HeaderBanner()
                    
                    // Quick Actions Grid
                    QuickActionsGrid(
                        showCheckIn: $showCheckIn,
                        showSelfCare: $showSelfCare,
                        showGratitude: $showGratitude,
                        showJournal: $showJournal
                    )
                    
                    // Your Week Card
                    YourWeekCard()
                    
                    // Explore Section
                    ExploreSection(selectedTab: $selectedTab)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct HeaderBanner: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Base Gradient
            MoodGradients.header
                .ignoresSafeArea()
            
            // Foliage silhouette in header
            LeafShape()
                .fill(Color.white.opacity(0.1))
                .frame(width: 150, height: 200)
                .rotationEffect(.degrees(30))
                .offset(x: 40, y: 20)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Good morning! 🌿")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("How's your heart today?")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    // Decorative plant illustration
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(20)
                .padding(.top, 40) // Status bar padding
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(0)
    }
}

struct QuickActionsGrid: View {
    @Binding var showCheckIn: Bool
    @Binding var showSelfCare: Bool
    @Binding var showGratitude: Bool
    @Binding var showJournal: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                QuickActionCard(
                    title: "Daily Check-in",
                    icon: "heart.fill",
                    color: .cyanBlue,
                    action: { showCheckIn = true }
                )
                
                QuickActionCard(
                    title: "Self-Care",
                    icon: "sparkles",
                    color: .softAqua,
                    action: { showSelfCare = true }
                )
                
                QuickActionCard(
                    title: "Gratitude",
                    icon: "star.fill",
                    color: .cyanBlue.opacity(0.8),
                    action: { showGratitude = true }
                )
                
                QuickActionCard(
                    title: "Journal",
                    icon: "book.fill",
                    color: .deepTeal,
                    action: { showJournal = true }
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

struct ExploreSection: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Explore")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.deepTeal)
                .padding(.horizontal, 16)
            
            VStack(spacing: 12) {
                ArticleCard(
                    title: "Mental Wellness Library",
                    illustration: "lightbulb.fill",
                    color: .softAqua,
                    action: { 
                        withAnimation {
                            selectedTab = .awareness
                        }
                    }
                )
                
                ArticleCard(
                    title: "Your Mood Calendar",
                    illustration: "calendar",
                    color: .cyanBlue,
                    action: { 
                        withAnimation {
                            selectedTab = .calendar
                        }
                    }
                )
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    NewHomeView()
}

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    isEnabled ? 
                    MoodGradients.button : 
                    LinearGradient(colors: [Color.softAqua.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(12)
                .shadow(color: Color.shadowColor.opacity(isEnabled ? 1.0 : 0.5), radius: 12, x: 0, y: 4)
        }
        .disabled(!isEnabled)
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.lightSky
        
        VStack(spacing: 20) {
            PrimaryButton(title: "Save Mood", action: {})
            PrimaryButton(title: "Disabled", action: {}, isEnabled: false)
        }
        .padding()
    }
}

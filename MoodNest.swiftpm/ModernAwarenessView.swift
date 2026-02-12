import SwiftUI

struct ModernAwarenessView: View {
    @State private var expandedTopic: String?
    @Binding var selectedTab: TabItem
    @Environment(\.dismiss) var dismiss
    
    let topics = [
        Topic(
            title: "Mindfulness Meditation",
            icon: "figure.mind.and.body",
            color: Color.deepTeal,
            content: "Mindfulness meditation is the practice of focusing your attention on the present moment with an attitude of openness and non-judgment. It involves observing thoughts, feelings, and sensations as they arise without trying to change them. Research shows that regular practice can significantly reduce symptoms of anxiety and depression by training the brain to respond less reactively to stress.\n\nTo begin, find a quiet space and sit comfortably. Focus on the sensation of your breath—the rise and fall of your chest or the feeling of air entering your nostrils. When your mind inevitably wanders, gently and kindly bring your attention back to your breath. Over time, this builds 'mental muscle' that helps you stay grounded even in challenging situations.",
            pros: ["Reduces stress", "Improves focus", "Better sleep"],
            cons: ["Requires practice", "Time commitment"]
        ),
        Topic(
            title: "Cognitive Behavioral Therapy",
            icon: "brain.head.profile",
            color: Color.cyanBlue,
            content: "CBT is a highly effective, evidence-based form of psychological treatment that focuses on the relationship between thoughts, feelings, and behaviors. The core principle is that our interpretations of events—rather than the events themselves—shape our emotional experiences. By identifying and challenging 'cognitive distortions' (unhelpful thought patterns), individuals can learn to respond to life's stressors more effectively.\n\nCBT often involves practical exercises like thought recording, where you document a distressing situation, the automatic thoughts that followed, and rational alternatives. This process helps 'rewire' the brain's baseline responses, leading to long-term improvements in mood and functioning. It is widely considered the gold standard for treating various mental health conditions.",
            pros: ["Evidence-based", "Practical tools", "Long-term benefits"],
            cons: ["Needs professional", "Can be challenging"]
        ),
        Topic(
            title: "Gratitude Practice",
            icon: "heart.text.square.fill",
            color: Color.softAqua,
            content: "Gratitude is more than just saying 'thank you.' It is a conscious effort to acknowledge the goodness in your life and recognize that the source of that goodness often lies outside yourself. Scientific studies have demonstrated that consistent gratitude practice can increase levels of dopamine and serotonin, the brain's 'feel-good' neurotransmitters, while reducing the stress hormone cortisol.\n\nA simple way to start is by keeping a daily gratitude journal. Each evening, write down three specific things you are thankful for from that day. They don't have to be major life events; even a warm cup of coffee or a kind word from a stranger counts. By training your brain to scan for the positive, you naturally become more resilient and optimistic.",
            pros: ["Boosts happiness", "Easy to start", "Free"],
            cons: ["Consistency needed", "May feel forced initially"]
        ),
        Topic(
            title: "Sleep Hygiene",
            icon: "moon.stars.fill",
            color: Color.deepTeal.opacity(0.8),
            content: "Sleep hygiene refers to a variety of practices and habits that are necessary to have good nighttime sleep quality and full daytime alertness. Since sleep and mental health are closely linked, improving your 'hygiene' can have a profound impact on your emotional stability. The body thrives on consistency, so maintaining a regular sleep-wake cycle is one of the most important factors.\n\nKey recommendations include creating a dark, cool, and quiet sleep environment, limiting caffeine and alcohol in the hours leading up to bed, and establishing a 'tech-free' buffer zone before sleep. Exposure to blue light from screens can suppress melatonin production, making it harder to fall asleep. By respecting your body's natural circadian rhythm, you allow your brain to perform critical restorative functions.",
            pros: ["Better rest", "More energy", "Improved mood"],
            cons: ["Lifestyle changes", "Takes time to adjust"]
        ),
        Topic(
            title: "Breathing Exercises",
            icon: "lungs.fill",
            color: Color.cyanBlue.opacity(0.8),
            content: "Controlled breathing is one of the fastest ways to influence your nervous system. When we are stressed, our 'fight or flight' response (sympathetic nervous system) takes over, leading to shallow breaths and a rapid heart rate. By consciously slowing down our breathing, we activate the 'rest and digest' response (parasympathetic nervous system), sending a signal to the brain that we are safe.\n\nA popular technique is 'Box Breathing': inhale for four seconds, hold for four, exhale for four, and hold for four. Another is the '4-7-8' method: inhale for four, hold for seven, and exhale forcefully for eight. These techniques provide an immediate physiological anchor, helping to manage acute anxiety or panic in the moment.",
            pros: ["Instant calm", "No equipment", "Anywhere, anytime"],
            cons: ["Easy to forget", "Requires focus"]
        ),
        Topic(
            title: "Setting Boundaries",
            icon: "shield.fill",
            color: Color.deepTeal.opacity(0.7),
            content: "Boundaries are essentially the 'rules of engagement' we establish for our relationships and ourselves. They are not about keeping people out, but about clearly communicating what behaviors we find acceptable and what we do not. Healthy boundaries protect our emotional energy and prevent the resentment that often grows from over-extending ourselves or saying 'yes' when we mean 'no.'\n\nBoundaries can be physical, emotional, or digital. For example, setting an emotional boundary might involve telling a friend, 'I care about you, but I don't have the capacity to discuss this heavy topic right now.' Learning to set boundaries requires self-awareness and the courage to prioritize your well-being, but it ultimately leads to more honest and sustainable connections with others.",
            pros: ["Protects energy", "Reduces stress", "Better relationships"],
            cons: ["Can feel uncomfortable", "May upset others"]
        ),
        Topic(
            title: "Emotional Regulation",
            icon: "heart.circle.fill",
            color: Color.cyanBlue.opacity(0.7),
            content: "Emotional regulation is the ability to monitor and manage your internal emotional state. It doesn't mean suppressing feelings; rather, it's about being able to feel an emotion and choose how to respond to it effectively. This skill is critical for navigating conflict, making sound decisions, and maintaining a sense of inner balance during life's ups and downs.\n\nOne powerful strategy is the 'STOP' technique: Stop what you're doing, Take a breath, Observe what's happening in your body and mind, and Proceed with awareness. By creating a small space between the emotion and your reaction, you regain control over your behavior. Developing this 'emotional agility' allows you to live more intentionally.",
            pros: ["Manage intense emotions", "Better decision-making", "Improved relationships"],
            cons: ["Takes practice", "Can be difficult at first"]
        ),
        Topic(
            title: "Social Anxiety",
            icon: "person.2.fill",
            color: Color.softAqua.opacity(0.9),
            content: "Social anxiety is more than just shyness; it involves an intense fear of being judged, evaluated, or rejected by others in social or performance situations. This can lead to avoiding activities or enduring them with significant distress. Understanding that social anxiety is a common experience and that most people are focused on their own insecurities can help reduce the pressure we put on ourselves.\n\nTreatment often involves 'gradual exposure,' where you slowly face feared situations in a controlled way. Combined with mindfulness and CBT, exposure helps desensitize the fear response. Remember that social skills are like muscles—they get stronger with practice. Focusing on the person you're talking to rather than your own performance can also significantly lower anxiety levels.",
            pros: ["Navigate social situations", "Build confidence", "Reduce avoidance"],
            cons: ["Gradual progress", "May need support"]
        ),
        Topic(
            title: "Mind-Body Connection",
            icon: "figure.yoga",
            color: Color.deepTeal.opacity(0.6),
            content: "The mind and body are not separate entities; they are part of a continuous feedback loop. What we think and feel has a direct impact on our physical health, and our physical state profoundly influences our mental wellbeing. For instance, chronic stress can manifest as muscle tension, headaches, or digestive issues, while physical movement can release endorphins that alleviate depression.\n\nHolistic practices like Yoga, Tai Chi, or even mindful walking emphasize this connection. By paying attention to bodily sensations while moving, you can release stored emotional tension. Taking care of your physical health through nutrition, hydration, and movement is a fundamental part of maintaining a healthy mind.",
            pros: ["Holistic wellness", "Physical benefits", "Mental clarity"],
            cons: ["Requires commitment", "Not a quick fix"]
        ),
        Topic(
            title: "Burnout Prevention",
            icon: "flame.fill",
            color: Color.cyanBlue.opacity(0.6),
            content: "Burnout is a state of emotional, physical, and mental exhaustion caused by excessive and prolonged stress. It occurs when you feel overwhelmed, emotionally drained, and unable to meet constant demands. Preventing burnout requires a proactive approach to workload management and regular 'recharging' of your internal battery before it hits zero.\n\nEarly warning signs include chronic fatigue, cynicism towards work, and a sense of reduced accomplishment. Prevention involves setting clear work-life boundaries, taking regular breaks, and engaging in activities that bring you joy outside of your primary responsibilities. Remember that self-care is not a luxury; it is a vital necessity for long-term health and productivity.",
            pros: ["Recognize warning signs", "Protect well-being", "Sustainable energy"],
            cons: ["Lifestyle changes needed", "May require boundaries"]
        ),
        Topic(
            title: "Digital Wellbeing",
            icon: "iphone.slash",
            color: Color.deepTeal.opacity(0.9),
            content: "In an age of constant connectivity, digital wellbeing is about having a healthy relationship with technology. It involves being intentional about how and when we use our devices to ensure they serve our lives rather than distract from them. High 'screen time' and social media comparison are often linked to increased anxiety and a distorted sense of reality.\n\nStrategies for digital wellbeing include setting 'no-tech' times (like during meals), turning off non-essential notifications, and curating your social media feeds to follow accounts that inspire rather than deflate you. A 'digital detox'—even for just a few hours—can help reset your focus and allow you to reconnect with the physical world around you.",
            pros: ["Healthy tech habits", "Better focus", "Improved sleep"],
            cons: ["FOMO challenges", "Requires discipline"]
        ),
        Topic(
            title: "Affirmations",
            icon: "quote.bubble.fill",
            color: Color.softAqua.opacity(0.8),
            content: "Affirmations are positive statements that you repeat to yourself to challenge negative thoughts and build self-esteem. While they may feel simple, the neurological impact is significant; repeating positive phrases can help strengthen the 'reward centers' in the brain and create new, more supportive neural pathways.\n\nEfficient affirmations are usually in the present tense, personal, and positive. Instead of saying 'I will be brave,' try 'I am capable of handling this challenge.' For affirmations to be effective, they should feel realistic to you. Combining them with deep breathing or looking in a mirror can enhance their impact. Over time, these small shifts in self-talk become the foundation of a more resilient self-image.",
            pros: ["Positive self-talk", "Boost confidence", "Easy to practice"],
            cons: ["May feel awkward", "Consistency needed"]
        )
    ]

    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { 
                    withAnimation {
                        selectedTab = .home
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.deepTeal)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.cyanBlue)
                    
                    Text("Mental Wellness Library")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.deepTeal)
                }
                
                Spacer()
                
                // Placeholder for symmetry
                Color.clear
                    .frame(width: 44)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.lightSky)
            .overlay(
                Rectangle()
                    .fill(Color.deepTeal.opacity(0.1))
                    .frame(height: 0.5),
                alignment: .bottom
            )
            
            // Subtitle
            Text("Explore topics to support your journey")
                .font(.system(size: 14))
                .foregroundColor(.cyanBlue)
                .padding(.top, 12)
                .background(Color.lightSky)
                .frame(maxWidth: .infinity)
                .background(Color.lightSky)
            
            // Topics Grid
            ZStack {
                DecorativeBackground(
                    gradient: LinearGradient(
                        colors: [Color.lightSky, Color.softAqua.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        ForEach(topics) { topic in
                            TopicCard(
                                topic: topic,
                                isExpanded: expandedTopic == topic.id,
                                onTap: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        expandedTopic = expandedTopic == topic.id ? nil : topic.id
                                    }
                                }
                            )
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color.lightSky)
    }
}

struct Topic: Identifiable {
    let id = UUID().uuidString
    let title: String
    let icon: String
    let color: Color
    let content: String
    let pros: [String]
    let cons: [String]
}

struct TopicCard: View {
    let topic: Topic
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon and Title
                VStack(spacing: 12) {
                    Image(systemName: topic.icon)
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    
                    Text(topic.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(height: 36)
                }
                
                // Read time badge
                HStack {
                    Text("3 min read")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                }
                
                // Expanded content
                if isExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        Text(topic.content)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pros:")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            ForEach(topic.pros, id: \.self) { pro in
                                HStack(alignment: .top, spacing: 4) {
                                    Text("•")
                                    Text(pro)
                                }
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cons:")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            ForEach(topic.cons, id: \.self) { con in
                                HStack(alignment: .top, spacing: 4) {
                                    Text("•")
                                    Text(con)
                                }
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(topic.color)
            .cornerRadius(16)
            .shadow(color: topic.color.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ModernAwarenessView(selectedTab: .constant(.awareness))
}

import SwiftUI

struct AwarenessView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentCapsule: AwarenessCapsule?
    @State private var animationKey = 0
    
    let capsules = [
        AwarenessCapsule(
            title: "Mindfulness Meditation",
            description: "A practice of being present in the moment without judgment, focusing on breath and bodily sensations.",
            pros: [
                "Reduces stress and anxiety",
                "Improves focus and concentration",
                "Enhances emotional regulation",
                "Can be practiced anywhere"
            ],
            cons: [
                "Requires consistent practice",
                "May be challenging for beginners",
                "Results take time to notice"
            ]
        ),
        AwarenessCapsule(
            title: "Journaling",
            description: "Writing down thoughts, feelings, and experiences to process emotions and gain self-awareness.",
            pros: [
                "Helps process complex emotions",
                "Tracks patterns over time",
                "Provides creative outlet",
                "Improves self-understanding"
            ],
            cons: [
                "Requires time commitment",
                "Can be emotionally challenging",
                "May feel awkward at first"
            ]
        ),
        AwarenessCapsule(
            title: "Cognitive Behavioral Therapy (CBT)",
            description: "A therapeutic approach that helps identify and change negative thought patterns and behaviors.",
            pros: [
                "Evidence-based effectiveness",
                "Teaches practical coping skills",
                "Addresses root causes",
                "Applicable to many conditions"
            ],
            cons: [
                "Requires professional guidance",
                "Can be expensive",
                "Needs active participation"
            ]
        ),
        AwarenessCapsule(
            title: "Physical Exercise",
            description: "Regular physical activity that releases endorphins and improves overall mental well-being.",
            pros: [
                "Natural mood booster",
                "Improves sleep quality",
                "Builds confidence",
                "Reduces stress hormones"
            ],
            cons: [
                "Requires physical ability",
                "Time and energy commitment",
                "Results not immediate"
            ]
        ),
        AwarenessCapsule(
            title: "Social Connection",
            description: "Maintaining meaningful relationships and engaging with supportive communities.",
            pros: [
                "Reduces feelings of isolation",
                "Provides emotional support",
                "Increases sense of belonging",
                "Offers different perspectives"
            ],
            cons: [
                "Requires vulnerability",
                "Can be draining for introverts",
                "Quality matters more than quantity"
            ]
        ),
        AwarenessCapsule(
            title: "Sleep Hygiene",
            description: "Practices and habits that promote consistent, quality sleep for mental and physical health.",
            pros: [
                "Improves mood regulation",
                "Enhances cognitive function",
                "Boosts immune system",
                "Increases energy levels"
            ],
            cons: [
                "Requires lifestyle changes",
                "Takes time to establish routine",
                "May need to limit screen time"
            ]
        ),
        AwarenessCapsule(
            title: "Gratitude Practice",
            description: "Regularly acknowledging and appreciating positive aspects of life, big or small.",
            pros: [
                "Shifts focus to positives",
                "Improves overall happiness",
                "Strengthens relationships",
                "Simple to implement"
            ],
            cons: [
                "Can feel forced initially",
                "Doesn't replace therapy",
                "Requires consistency"
            ]
        ),
        AwarenessCapsule(
            title: "Setting Boundaries",
            description: "Establishing clear limits on what you will and won't accept in relationships and commitments.",
            pros: [
                "Protects mental energy",
                "Reduces resentment",
                "Improves self-respect",
                "Clarifies priorities"
            ],
            cons: [
                "May cause initial conflict",
                "Requires assertiveness",
                "Can feel uncomfortable"
            ]
        ),
        AwarenessCapsule(
            title: "Digital Detox",
            description: "Intentionally reducing or eliminating screen time and social media usage for mental clarity.",
            pros: [
                "Reduces comparison anxiety",
                "Improves sleep quality",
                "Increases present-moment awareness",
                "Frees up time for other activities"
            ],
            cons: [
                "May feel disconnected",
                "Difficult in digital-dependent jobs",
                "FOMO (fear of missing out)"
            ]
        ),
        AwarenessCapsule(
            title: "Breathing Exercises",
            description: "Controlled breathing techniques that activate the body's relaxation response.",
            pros: [
                "Immediate calming effect",
                "Can be done anywhere",
                "No equipment needed",
                "Scientifically proven benefits"
            ],
            cons: [
                "Effects are temporary",
                "Requires practice to master",
                "May feel silly at first"
            ]
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("💡")
                            .font(.system(size: 60))
                        
                        Text("Mental Health Awareness")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Learn about different mental health practices")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Capsule Card
                    if let capsule = currentCapsule {
                        VStack(alignment: .leading, spacing: 16) {
                            // Title
                            Text(capsule.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            // Description
                            Text(capsule.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Pros
                            if let pros = capsule.pros, !pros.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Pros")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                    
                                    ForEach(pros, id: \.self) { pro in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(.green)
                                            Text(pro)
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                .padding(.top, 4)
                            }
                            
                            // Cons
                            if let cons = capsule.cons, !cons.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cons")
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                    
                                    ForEach(cons, id: \.self) { con in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(.orange)
                                            Text(con)
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        .id(animationKey)
                    }
                    
                    // Learn Another Button
                    Button(action: {
                        loadRandomCapsule()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Learn Another")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Awareness")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if currentCapsule == nil {
                currentCapsule = capsules.randomElement()
            }
        }
    }
    
    func loadRandomCapsule() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentCapsule = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentCapsule = capsules.randomElement()
                animationKey += 1
            }
        }
    }
}

struct AwarenessCapsule {
    let title: String
    let description: String
    let pros: [String]?
    let cons: [String]?
}

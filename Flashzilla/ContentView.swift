//
//  ContentView.swift
//  Flashzilla
//
//  Created by Esben Viskum on 22/05/2021.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
//    @State private var currentAmount: CGFloat = 0
//    @State private var finalAmount: CGFloat = 1
//    @State private var currentAmount: Angle = .degrees(0)
//    @State private var finalAmount: Angle = .degrees(0)
//    @State private var offset = CGSize.zero
//    @State private var isDragging = false
    @State private var engine: CHHapticEngine?
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    func simpleWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    func simpleError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1-i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1-i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1+i)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
    
//    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
//    @State private var counter = 0
    
    func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        if UIAccessibility.isReduceMotionEnabled {
            return try body()
        } else {
            return try withAnimation(animation, body)
        }
    }
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
//    @State private var cards = [Card](repeating: Card.example, count: 10)
    @State private var cards = [Card]()

    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingEditScreen = false
    @State private var replayWrongAnswer = false
    @State private var showingSettingScreen = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
    }
    
    func resetCards() {
        cards = [Card](repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        loadData()
    }
        
    func rotateCards() {
        
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(timeRemaining == 0 ? "Time is up!" : "Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: self.cards[index]) { wrongAnswer in
                            withAnimation {
                                if wrongAnswer && replayWrongAnswer {
                                    let tmpCard = cards[index]
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    self.cards.insert(tmpCard, at: 0)
                                    }
                                }
                                self.removeCard(at: index)

                                if cards.isEmpty && !(wrongAnswer && replayWrongAnswer) {
                                    isActive = false
                                }
                            }
                        }
                        .stacked(at: index, in: self.cards.count)
                        .allowsHitTesting(index == self.cards.count - 1)
                        .accessibility(hidden: index < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        self.showingSettingScreen = true
                    }) {
                        Image(systemName: "wrench.and.screwdriver")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }

                    Spacer()
                    
                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                cards = []
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        .sheet(isPresented: $showingSettingScreen, onDismiss: resetCards) {
            SettingsView(replayWrongAnswer: $replayWrongAnswer)
        }
        .onAppear(perform: resetCards)


        
        
/*        Text("Hello World")
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                print("Moving to the background")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("Moving back to the foreground")
            }
            . onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                print("User took a screenshot")
            } */
        
/*        Text("Hello World")
            .onReceive(timer) { time in
                if self.counter == 5 {
                    self.timer.upstream.connect().cancel()
                } else {
                    print("The time is now \(time)")
                }
                self.counter += 1
            } */
        
/*        VStack {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("VStack tapped")
        } */
        
/*        ZStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped")
                }
            
            Circle()
                .fill(Color.red)
                .frame(width: 300, height: 300)
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Circle tapped")
                }
//                .allowsHitTesting(false)
        } */
        
/*        VStack {
            Text("Simple Success")
                .onTapGesture(perform: {
                    simpleSuccess()
                })
                .padding()

            Text("Simple Warning")
                .onTapGesture(perform: {
                    simpleWarning()
                })
                .padding()

            Text("Simple Error")
                .onTapGesture(perform: {
                    simpleError()
                })
                .padding()

            Text("Complex Success")
                .onAppear(perform: {
                    prepareHaptics()
                })
                .onTapGesture(perform: {
                    complexSuccess()
                })
                .padding()
        } */

        
/*        let dragGesture = DragGesture()
            .onChanged { value in self.offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    self.offset = .zero
                    self.isDragging = false
                }
            }
        
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    self.isDragging = true
                }
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        return Circle()
            .fill(Color.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1.0)
            .offset(offset)
            .gesture(combined) */
        
        
/*        VStack {
            Text("Hello world")
                .onTapGesture {
                    print("Text tapped")
                }
        }
//        .highPriorityGesture(
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    print("VStack tapped")
                })
//        .onTapGesture {
//            print("VStack tapped")
//        } */
        
        
/*        Text("Hello World")
            .rotationEffect(finalAmount + currentAmount)
            .gesture(
                RotationGesture()
                    .onChanged { angle in
                        print("onChanged: \(angle)")
                        self.currentAmount = angle
                    }
                    .onEnded { angle in
                        print("onEnded: \(angle)")
                        self.finalAmount += self.currentAmount
                        self.currentAmount = .degrees(0)
                    }
            ) */

        
/*        Text("Hello World")
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { amount in
                        print("onChanged: \(amount)")
                        self.currentAmount = amount - 1
                    }
                    .onEnded { amount in
                        print("onEnded: \(amount)")
                        self.finalAmount += self.currentAmount
                        self.currentAmount = 0
                    }
            ) */
        
        
        /*        Text("Hello, world!")
            .onTapGesture(count: 2, perform: {
                print("Double tapped!")
            })
//            .onLongPressGesture {
//                print("Standard long pressed")
//            }
            .onLongPressGesture(minimumDuration: 4, pressing: { inProgress in
                print("In progress \(inProgress)")
            }) {
                print("Loooong pressed!")
            }
            .padding() */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

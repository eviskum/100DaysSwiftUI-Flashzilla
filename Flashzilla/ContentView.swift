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

    var body: some View {

        VStack {
            Text("Success")
                .onTapGesture(perform: {
                    simpleSuccess()
                })
                .padding()

            Text("Warning")
                .onTapGesture(perform: {
                    simpleWarning()
                })
                .padding()

            Text("Error")
                .onTapGesture(perform: {
                    simpleError()
                })
                .padding()
        }

        
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

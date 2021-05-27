//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Esben Viskum on 27/05/2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var replayWrongAnswer: Bool

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Game settings")) {
                    Toggle(isOn: $replayWrongAnswer, label: {
                        Text("Replay wrong answers")
                    })
                }
            }
            .navigationBarTitle("Edit Settings")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismiss)
                }
            })
//            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(replayWrongAnswer: .constant(false))
    }
}

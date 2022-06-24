//
//  ActionsView.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 13/05/21.
//

import SwiftUI

struct ActionsView: View {
    var action = ActionsViewModel()
    @State var altitude: String = ""
    @FocusState var isAltitudeFocused: Bool
    
    var body: some View {
        List(action.actions, id: \.text) { action in
            
            if action.text == "Set RTL Altitude" || action.text == "Set takeoff Altitude" {
                HStack {
                    ButtonContent(text: action.text, action: {
                        self.action.altitude = Float(self.altitude) ?? 0.0
                        self.action.takeoffAltitude = Float(self.altitude) ?? 0.0
                        action.action()
                        isAltitudeFocused = false
                    })
                    TextField("高度", text: $altitude)
                        .textFieldStyle(.plain)
                        .frame(width: 80, height: 30, alignment: .center)
                        .focused($isAltitudeFocused)
                }
            } else {
                ButtonContent(text: action.text, action: action.action)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionsView()
    }
}

struct ButtonContent: View {
    @State var text: String
    @State var action: () -> ()
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: action, label: {
                Text(text)
                    .font(.system(size: 14, weight: .medium, design: .default))
            })
            Spacer()
        }
        .padding()
    }
}

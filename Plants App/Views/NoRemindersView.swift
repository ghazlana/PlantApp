//
//  NoRemindersView.swift
//  Plants App
//
//  Created by ghazlan aldosari on 01/06/1448 AH.
//

import Foundation
import SwiftUI

struct NoRemindersView: View {

    // An action provided by ContentView
    var onAddReminder: () -> Void

    var body: some View {

        ZStack {

            // Message shown when there are no plants
            Text("No reminders set yet...")
                .foregroundStyle(.gray)

            // Button to open the reminder form
            Button {
                onAddReminder()
            } label: {

                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .padding(14)
                    .background( Color(
                        red: 51.0 / 255,
                        green: 128.0 / 255,
                        blue: 105.0 / 255
                    ))
                    .clipShape(Circle())
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottomTrailing
            )
            .padding(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

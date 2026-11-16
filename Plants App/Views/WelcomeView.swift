//
//  WelcomeView.swift
//  Plants App
//
//  Created by ghazlan aldosari on 01/06/1448 AH.
//

import Foundation
import SwiftUI

struct WelcomeView: View {

    // ContentView tells us what to do when the button is tapped
    var onSetReminder: () -> Void

    var body: some View {

        VStack(spacing: 70) {

            Spacer()

            // Plant image
            Image("plant")
                .resizable()
                .scaledToFit()
                .frame(width: 190, height: 190)
                .padding(.top, -180)
            VStack(spacing: 15) {
                // Welcome title
                Text("Start your plant journey!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                // Description
                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            // Opens the reminder form
            Button("Set Plant Reminder") {
                onSetReminder()
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Color(
                    red: 51.0 / 255,
                    green: 128.0 / 255,
                    blue: 105.0 / 255
                )
            )
            .clipShape(Capsule())
            .padding(.horizontal, 35)
            .padding(.top, 20)

            Spacer()
        }
    }
}

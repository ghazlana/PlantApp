//
//  AllDoneView.swift
//  Plants App
//
//  Created by ghazlan aldosari on 03/06/1448 AH.
//

import Foundation
import SwiftUI

struct AllDoneView: View {

    var onAddReminder: () -> Void

   
    var body: some View {

      //  ZStack {

            // Center the plant illustration and messages
            VStack(spacing: 70) {

                Image("plantWinking")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                  // .padding(.top, -150)
                   //.offset(y: -20)

                VStack(spacing: 10){
                    Text("All Done! 🎉")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        //.foregroundStyle(.white)
                    
                    Text("All Reminders Completed")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }.offset(y: -80)

      //  }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {

            // Add Reminder button
            Button {
                onAddReminder()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(
                        Color(
                            red: 51.0 / 255,
                            green: 128.0 / 255,
                            blue: 105.0 / 255
                        )
                    )
                    .clipShape(Circle())
            }
            .padding(25)
        }
    }

}

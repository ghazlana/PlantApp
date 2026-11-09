import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var reminderForm = false
    @State private var plantName = ""
    @State private var plantRoom = ""
    
    var body: some View {
        VStack(spacing: 20)  {
            Text("My Plants 🌱")
                //.font(.title)
                .font(.system(size: 38))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)

            Spacer()
            
            //plant image
            Image("plant")
                .resizable()
                .scaledToFit()
                .frame(width: 190, height: 190)
                .padding(.top, -30)
            
            //welcome
            Text("Start your plant journey!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
            
            //Description
            Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                .font(.caption)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
            //reminder button
            Button("Set Plant Reminder"){
reminderForm = true
            }
            .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.green)
                .clipShape(Capsule())
                .padding(.horizontal, 35)
                .padding(.top, 30)
            
            

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
        
                .sheet(isPresented: $reminderForm){
                    VStack(alignment: .leading, spacing: 20) {

                            Text("Set Plant Reminder")
                                .font(.title2)
                                .fontWeight(.bold)
                        
                       //Space between text and text field
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Plant Name")
                            
                            TextField("Enter plant name", text: $plantName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Plant Room")
                            
                            TextField("Enter room", text: $plantRoom)
                                .textFieldStyle(.roundedBorder)
                        }
                            Spacer()
                        }
                        .padding()
                }
    }
}

#Preview {
    ContentView()
}



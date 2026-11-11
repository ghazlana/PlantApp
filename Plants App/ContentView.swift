import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var reminderForm = false
    @State private var plantName = ""
    @State private var plantRoom = "Bedroom"
    @State private var wateringFrequency = 3
    @State private var wateringTime = Date()
    @State private var plants: [Plant] = []
    @State private var hasOpenedReminderForm = false
    @State private var plantLight = "Full sun"
    @State private var plantWater = "20-50 ml"
    
    
    var body: some View {
        VStack(spacing: 20)  {
            Text("My Plants 🌱")
            //.font(.title)
                .font(.system(size: 38))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)
            
            
            if plants.isEmpty && !hasOpenedReminderForm{
                
                
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
                    hasOpenedReminderForm = true
                    reminderForm = true
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(red: 51.0 / 255, green: 128.0 / 255, blue: 105.0 / 255))
                .clipShape(Capsule())
                .padding(.horizontal, 35)
                .padding(.top, 30)
                
                
                
                Spacer()
            } else if plants.isEmpty{
                
                
                ZStack {
                    
                    Text("No reminders set yet...")
                        .foregroundStyle(.gray)
                    
                    Button {
                        reminderForm = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .padding(14)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity,
                           alignment: .bottomTrailing)
                    .padding(25)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                
                // Show the plants after the user adds them
                ForEach($plants) { $plant in
                    
                    HStack(spacing: 12) {
                        
                        Button {
                            plant.isWatered.toggle()
                        } label: {
                            Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(plant.isWatered ? .green : .gray)
                                .font(.system(size: 22))
                        }
                        .buttonStyle(.plain)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            HStack{
                                Image(systemName: "location").foregroundStyle(.gray)
                                
                                Text("in " + plant.room)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            
                            Text(plant.name)
                                .font(.system(size: 30))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            
                            HStack{
                                Image(systemName: "sun.max")                      .foregroundStyle((Color(red: 204 / 255 , green: 199 / 255 , blue: 133 / 255 )))

                                
                                Text(plant.light)
                                    .font(.caption)
                                    .foregroundStyle((Color(red: 204 / 255 , green: 199 / 255 , blue: 133 / 255 )))

                                
                                Image(systemName: "drop").foregroundStyle((Color(red: 202 / 255 , green: 243 / 255 , blue: 251 / 255 )))
                                
                                Text(plant.water)
                                    .font(.caption)
                                    .foregroundStyle((Color(red: 202 / 255 , green: 243 / 255 , blue: 251 / 255 )))
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                    }
                    Spacer()
                    
                 
                }
                Button {
                    reminderForm = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .padding(14)
                        .background(Color(red: 51.0 / 255, green: 128.0 / 255, blue: 105.0 / 255))
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity,
                       alignment: .bottomTrailing)
                .padding(25)
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        //form
        .sheet(isPresented: $reminderForm){
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                
                    Button {
                        reminderForm = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Set Reminder")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Save button
                    Button {
                        let newPlant = Plant(
                            name: plantName,
                            room: plantRoom,
                            light: plantLight,
                            water: plantWater,
                            wateringFrequency:
                                wateringFrequency,
                            wateringTime: wateringTime
                        )
                        
                        plants.append(newPlant)
                        reminderForm = false
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(Color(red: 51.0 / 255, green: 128.0 / 255, blue: 105.0 / 255))
                            .clipShape(Circle())
                    }
                }.padding(.top, 20)
                    .padding(.horizontal, 20)
                
                
                //Space between text and text field
                VStack(alignment: .leading, spacing: 45) {
                    
                    
                    //  PlantTextField(title: "Plant Name", text: $plantName)                     }
                    HStack(spacing: 8) {
                        
                        Text("Plant Name")
                            .foregroundStyle(.white)
                        
                        TextField("Pothos", text: $plantName)
                            .foregroundStyle(.white)
                        
                    }
                    .padding(16)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                    
                    VStack(spacing: 0) {
                        HStack {

                                Image(systemName: "location")
                                    .foregroundStyle(.white)

                                Text("Room")
                                    .foregroundStyle(.white)

                                Spacer()
                        
                        Picker("Plant Room", selection: $plantRoom) {
                            
                            Text("Bedroom").tag("Bedroom")
                            
                            Text("Living Room").tag("Living Room")
                            
                            Text("Kitchen").tag("Kitchen")
                            
                            Text("Bathroom").tag("Bathroom")
                            
                            Text("Balcony").tag("Balcony")
                            
                            
                        }
                        .pickerStyle(.menu)//wheel
                        .tint(.gray)
                         .labelsHidden()
                     }
                     .padding(8)

                        Divider()
                                .background(Color.gray)
                    // Light
                    
                        HStack {
                            
                            Image(systemName: "sun.max")
                                .foregroundStyle(.white)
                            
                            Text("Light")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Picker("Plant Light", selection: $plantLight) {
                                
                                Text("Full Sun").tag("Full sun")
                                
                                Text("Partial Sun").tag("Partial Sun")
                                
                                Text("Low Light").tag("Low Light")
                                
                                
                            }
                        
                        .pickerStyle(.menu)//wheel
                        .tint(.gray)
                         .labelsHidden()
                     }
                     .padding(8)
                        


                 }
                 .background(Color.gray.opacity(0.2))
                 .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "drop")
                                .foregroundStyle(.white)
                            
                            Text("Watering Days")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Picker("Watering Frequency", selection: $wateringFrequency) {
                                
                                Text("Every day").tag(1)
                                
                                Text("Every 2 days").tag(2)
                                
                                Text("Every 3 days").tag(3)
                                
                                Text("Once a week").tag(7)
                                
                                Text("Every 10 days").tag(10)
                                
                                Text("Every 2 weeks").tag(14)
                                
                            }
                            
                            .pickerStyle(.menu)
                            .tint(.gray)
                            .labelsHidden()
                        }.padding(8)
                        
                        Divider()
                                .background(Color.gray)
                        
                        HStack {
                            
                            Image(systemName: "drop")
                                .foregroundStyle(.white)
                            
                            Text("Water")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Picker("Plant water", selection: $plantWater) {
                                
                                Text("20-50 ml").tag("20-50 ml")
                                
                                Text("50-100 ml").tag("50-100 ml")
                                
                                Text("100-200 ml").tag("100-200 ml")
                                
                                Text("200-300 ml").tag("200-300 ml")
                                
                                
                            }
                        
                        .pickerStyle(.menu)//wheel
                        .tint(.gray)
                         .labelsHidden()
                     }
                     .padding(8)
                        
                        
                        }
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                   /* DatePicker(
                        "Watering Time",
                        selection: $wateringTime,
                        displayedComponents: .hourAndMinute
                    )*/
                    
                    /*Button("Save Reminder") {
                     
                     // Create a plant using the user's information
                     let newPlant = Plant(
                     name: plantName,
                     room: plantRoom,
                     wateringFrequency: wateringFrequency,
                     wateringTime: wateringTime
                     )
                     // Add the new plant to the plants array
                     plants.append(newPlant)
                     
                     // To close the sheet
                     reminderForm = false
                     }*/
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.10, green: 0.10, blue: 0.10))
                .preferredColorScheme(.dark)
            }
        }
    }
}

struct PlantTextField: View {

    let title: String

    @Binding var text: String

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)

            TextField("Enter \(title)", text: $text)
                .padding(14)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct Plant: Identifiable {
    
    let id = UUID()// Gives unique id for each plant
    
    var name: String
    
    var room: String
    
    var light: String
    
    var water: String
    
    var wateringFrequency: Int
    
    var wateringTime: Date
    
    var isWatered: Bool = false
}

#Preview {
    ContentView()
}



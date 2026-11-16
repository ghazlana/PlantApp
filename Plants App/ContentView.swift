import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var reminderForm = false
    //@State private var plantName = ""
    //@State private var plantRoom = "Bedroom"
    //@State private var wateringFrequency = 3
    //@State private var wateringTime = Date()
    //@State private var plants: [Plant] = []
    @State private var viewModel = PlantViewModel()
    @State private var hasOpenedReminderForm = false
    //@State private var plantLight = "Full sun"
    //@State private var plantWater = "20-50 ml"
    
    @State private var selectedPlant: Plant? = nil // Stores the plant the user wants to edit
    
    
    var body: some View {
        VStack(spacing: 20)  {
            Text("My Plants 🌱")
            //.font(.title)
                .font(.system(size: 38))
              //  .fontWeight(.native) //native
               // .foregroundStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)
            
            
            if viewModel.plants.isEmpty && !hasOpenedReminderForm{
                
                WelcomeView {
                      hasOpenedReminderForm = true
                      reminderForm = true
                  }
               
            } else if viewModel.plants.isEmpty{
                
                NoRemindersView {
                    reminderForm = true
                }

            } else if viewModel.wateringProgress == 1.0 {

                AllDoneView(
                    onAddReminder: {
                        reminderForm = true
                    }
                )
            } else {
                
                PlantListView(
                    plants: viewModel.plants,
                    
                   

                    onAddReminder: {
                        reminderForm = true
                    },

                    onToggleWatered: { plant in
                        viewModel.toggleWatered(for: plant)
                    },
                    
                    onEditPlant: { plant in
                          selectedPlant = plant
                          print("Selected plant: \(plant.name)")
                      },
                    
                    onDeletePlant: { plant in
                        viewModel.deletePlant(plant)
                    },
                    
                    wateringProgress: viewModel.wateringProgress,
                    
                    progressMessage: viewModel.progressMessage

                )
            }
            
   
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.black)
        .preferredColorScheme(.dark)

        //form
        .sheet(isPresented: $reminderForm){
            ReminderFormView(
                    onSave: { plant in

                        // Add the new plant through the ViewModel
                        viewModel.addPlant(plant)

                        // Close the form
                        reminderForm = false
                    },

                    onCancel: {
                        // Close without saving
                        reminderForm = false
                    }
                )
            
            }
        
        // Opens the editing sheet when a plant is selected
        
        .sheet(item: $selectedPlant) { plant in

            ReminderFormView(
                editingPlant: plant,

                onSave: { updatedPlant in

                    // Update the existing plant in the ViewModel
                    viewModel.updatePlant(updatedPlant)

                    // Close the editing sheet
                    selectedPlant = nil
                },

                onCancel: {
                    // Close without saving
                    selectedPlant = nil
                },
                onDelete: { plantToDelete in

                    // Delete the selected plant
                    viewModel.deletePlant(plantToDelete)

                    // Close the editing sheet
                    selectedPlant = nil
                }

            )
        }
            
            }
}

/*struct PlantTextField: View {

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
}*/


#Preview {
    ContentView()
        .preferredColorScheme(.dark)


}



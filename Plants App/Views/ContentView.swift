import SwiftUI
import Playgrounds

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var reminderForm = false
    @State private var viewModel = PlantViewModel()
    
   // @State private var hasOpenedReminderForm = false
    @AppStorage("hasOpenedReminderForm") private var hasOpenedReminderForm = false //@AppStorage saves the value on the device, so Planto remembers it when you reopen the app.
    
    @State private var selectedPlant: Plant? = nil // Stores the plant the user wants to edit
    
    // Store the plant the user wants to delete
    @State private var plantToDelete: Plant? = nil

    // Show the delete alert from the plant list
    @State private var showListDeleteAlert = false

    // Show the delete alert from the editing form
    @State private var showEditDeleteAlert = false
    
    private let notifications = Notifications()
    
    var body: some View {
        VStack(spacing: 20)  {
            Text("My Plants 🌱")
           // .font(.largeTitle)
                .font(.system(size: 38))
                .fontWeight(.bold)
               // .foregroundStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)
            // A thin line under the title
            Divider()
                .background(Color.gray)
            
            
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
                        // Remember the plant and ask before deleting it
                        plantToDelete = plant
                        showListDeleteAlert = true
                    },
                    
                    wateringProgress: viewModel.wateringProgress,
                    
                    progressMessage: viewModel.progressMessage

                )
            }
            
   
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Confirm deletion from the plant list
        .alert(
            "Delete Reminder",
            isPresented: $showListDeleteAlert,
            presenting: plantToDelete
        ) { plant in

            Button("Cancel", role: .cancel) {
                plantToDelete = nil
            }

            Button("Delete", role: .destructive) {
                notifications.cancelNotification(for: plant)
                viewModel.deletePlant(plant)
                plantToDelete = nil
            }

        } message: { plant in
            Text("Are you sure you want to delete this reminder")
        }



        //.background(Color.black)
        .onAppear {

            // If I already have plants, I have used the app before
            if !viewModel.plants.isEmpty {
                hasOpenedReminderForm = true
            }
            
            
           //skips two days to test that unchecking works
          /*  viewModel.resetWateringIfNeeded(
                at: Date().addingTimeInterval(2 * 24 * 60 * 60)
            )*/

            notifications.checkPendingNotifications()

            // Check the original creation time saved for each plant
            for plant in viewModel.plants {
                print("Plant: \(plant.name)")
                print("Created at: \(plant.wateringTime)")
                print("Watering every: \(plant.wateringFrequency) days")
            }
        }
        
        // Check watering deadlines when the app becomes active
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                viewModel.resetWateringIfNeeded()
            }
        }
        
        //.preferredColorScheme(.dark)

        //form
        .sheet(isPresented: $reminderForm){
            ReminderFormView(
                    onSave: { plant in

                        // Add the new plant through the ViewModel
                        viewModel.addPlant(plant)

                        // Ask for permission, then schedule the reminder
                        notifications.requestPermission(for: plant)
                        
                        // Close the form
                        reminderForm = false
                    },

                    onCancel: {
                        // Close without saving
                        reminderForm = false
                    }
                )
 // to test notifications
/*.onAppear {
                notifications.scheduleTestNotification()            }*/
            
            // TEMPORARY: Check saved notifications when the app opens
           
            }
        
        // Opens the editing sheet when a plant is selected
        
        .sheet(item: $selectedPlant) { plant in

            ReminderFormView(
                editingPlant: plant,

                onSave: { updatedPlant in

                    // Update the existing plant in the ViewModel
                    viewModel.updatePlant(updatedPlant)
                    
                    
                    // Update the notification only if the watering frequency changed
                    // This prevents restarting the countdown when editing other information
                    if plant.wateringFrequency != updatedPlant.wateringFrequency {
                        // Update the plant's watering notification
                        notifications.scheduleCreationTimeNotification(for: updatedPlant)
                    }
                    
                    // Close the editing sheet
                    selectedPlant = nil
                },

                onCancel: {
                    // Close without saving
                    selectedPlant = nil
                },
                onDelete: { plant in
                    // Remember the plant and show the alert
                    plantToDelete = plant
                    showEditDeleteAlert = true
                }

            )
            .alert(
                "Delete Reminder",
                isPresented: $showEditDeleteAlert,
                presenting: plantToDelete
            ) { plant in

                Button("Cancel", role: .cancel) {
                    plantToDelete = nil
                }

                Button("Delete", role: .destructive) {
                    notifications.cancelNotification(for: plant)
                    viewModel.deletePlant(plant)
                    selectedPlant = nil
                    plantToDelete = nil
                }

            } message: { plant in
                Text("Are you sure you want to delete this reminder?")
            }
        }
            
            }
}




#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}



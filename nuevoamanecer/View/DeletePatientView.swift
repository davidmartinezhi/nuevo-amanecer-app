//
//  DeletePatientConfirmation.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 29/05/23.
//

import SwiftUI

struct DeletePatientView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var patients: PatientsViewModel
    @State var patient: Patient
    @State private var showAlert = false

    var body: some View {
        HStack {
            Button(action: {
                showAlert = true
            }) {
                HStack {
                    Text("Eliminar")
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                }
            }
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .foregroundColor(.white)
            .frame(maxWidth: 170)
            .alert(isPresented: $showAlert) { () -> Alert in
                Alert(title: Text("Confirmar Eliminación"),
                      message: Text("¿Estás seguro de que quieres eliminar a este paciente? Esta acción no se puede deshacer."),
                      primaryButton: .destructive(Text("Eliminar")) {
                        // Aquí va la lógica para eliminar al paciente
                    Task{
                        await patients.deleteData(patient: patient){ error in
                            if error != "OK"{
                                print(error)
                            }else{
                                //change to AdminView
                                Task {
                                    if let patientsList = await patients.getData(){
                                        DispatchQueue.main.async {
                                            self.patients.patientsList = patientsList
                                        }
                                    }
                                }
                                dismiss()
                            }
                        }
                    }

                      },
                      secondaryButton: .cancel())
                     
            }
            Spacer()
        }
    }
}

struct DeletePatientView_Previews: PreviewProvider {
    static var previews: some View {
        DeletePatientView(patients: PatientsViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()))
    }
}

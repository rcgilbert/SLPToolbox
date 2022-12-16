//
//  PatientCellView.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import SwiftUI

struct PatientCellView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.undoManager) private var undoManager
    
    @StateObject var patient: Patient
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            TextField("Data Title", text: $patient.wrappedName, prompt: Text("Enter Text"))
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
            
            HStack {
                Spacer()
                HStack {
                    VStack {
                        Text("Correct")
                            .font(.headline)
                            .frame(minWidth: 50)
                        Text(NSNumber(value: patient.correctCount), formatter: countFormatter)
                            .font(.title)
                            .frame(minWidth: 50)
                        Button {
                            patient.correctCount += 1
                            save()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                        }
                    }
                }
                Spacer()
                HStack {
                    VStack {
                        Text("Incorrect")
                            .font(.headline)
                            .frame(minWidth: 50)
                         Text(NSNumber(value: patient.incorrectCount), formatter: countFormatter)
                             .font(.title)
                             .frame(minWidth: 50)
                        Button {
                            patient.incorrectCount += 1
                            save()
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                        }
                    }
                }
                Spacer()
            }
            VStack(alignment: .center) {
                Text("\(patient.correctCountString) / \(patient.totalString) _=_ \(patient.percentageCorrectString)")
                    .font(.title3)
            }
        }
        .padding()
        .onChange(of: patient.name) { _ in
            save()
        }
    }
    
    private func save() {
        print("saving!")
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct PatientCellView_Previews: PreviewProvider {
    static var previews: some View {
        let patient = Patient(context: PersistenceController.preview.container.viewContext)
        patient.name = "Elvis"
        patient.timestamp = Date()
        
        return PatientCellView(patient: patient)
            .frame(height: 300)
    }
}

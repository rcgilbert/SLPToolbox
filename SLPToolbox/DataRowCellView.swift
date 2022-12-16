//
//  DataRowCellView.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import SwiftUI

struct DataRowCellView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.undoManager) private var undoManager
    
    @StateObject var dataRow: DataRow
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            TextField("Data Title", text: $dataRow.wrappedName, prompt: Text("Enter Text"))
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
                        Text(NSNumber(value: dataRow.correctCount), formatter: countFormatter)
                            .font(.title)
                            .frame(minWidth: 50)
                        Button {
                            dataRow.correctCount += 1
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
                         Text(NSNumber(value: dataRow.incorrectCount), formatter: countFormatter)
                             .font(.title)
                             .frame(minWidth: 50)
                        Button {
                            dataRow.incorrectCount += 1
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
                Text("\(dataRow.correctCountString) / \(dataRow.totalString) _=_ \(dataRow.percentageCorrectString)")
                    .font(.title3)
            }
        }
        .padding()
        .onChange(of: dataRow.name) { _ in
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

struct DataRowCellView_Previews: PreviewProvider {
    static var previews: some View {
        let dataRow = DataRow(context: PersistenceController.preview.container.viewContext)
        dataRow.name = "Elvis"
        dataRow.timestamp = Date()
        
        return DataRowCellView(dataRow: dataRow)
            .frame(height: 300)
    }
}

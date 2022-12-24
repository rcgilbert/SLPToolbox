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
    
    @ObservedObject var dataRow: DataRow
    
    var body: some View {
        VStack {
            TextField("Data Title", text: $dataRow.wrappedName, prompt: Text("Enter Text"))
                .font(.title2)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
                .multilineTextAlignment(.leading)
                .padding()
            HStack {
                ProgressView(value: dataRow.percentageCorrect) {
                    VStack(alignment: .center, spacing: 8) {
                        Text(dataRow.percentageCorrectString)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        Text("\(dataRow.correctCountString) / \(dataRow.totalString)")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                }.progressViewStyle(
                    GaugeProgressStyle(stroke: .angularGradient(colors: [.yellow, .orange,
                                                                         .red, .orange, .yellow],
                                                                center: .center,
                                                                startAngle: .degrees(0),
                                                                endAngle: .degrees(360)),
                                       strokeWidth: 10)
                )
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 150, height: 150)
                .scaledToFit()
                VStack(alignment: .trailing, spacing: 16) {
                    Button {
                        dataRow.correctCount += 1
                        save()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(idealWidth: 50, idealHeight: 50)
                            .foregroundColor(.green)
                    }
                    Spacer()
                    Button {
                        dataRow.incorrectCount += 1
                        save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(idealWidth: 50, idealHeight: 50)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .onChange(of: dataRow.name) { _ in
                    save()
            }
            }
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

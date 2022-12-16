//
//  ContentView.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import SwiftUI
import CoreData
import Combine

struct DataTrackView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.undoManager) private var undoManager

    @FetchRequest(fetchRequest: DataTrack.latestDataTrackRequest,
                  animation: .default)
    private var dataTrack: FetchedResults<DataTrack>
    
    private let undoObservers = Publishers.Merge3(NotificationCenter.default.publisher(for: .NSUndoManagerDidCloseUndoGroup),
                                                          NotificationCenter.default.publisher(for: .NSUndoManagerDidUndoChange),
                                                          NotificationCenter.default.publisher(for: .NSUndoManagerDidRedoChange))
    
    @State var undoDisabled: Bool = true
    @State var redoDisabled: Bool = true
    
    var body: some View {
        List {
            Section {
                ForEach(dataTrack.first?.dataRowsArray ?? []) { item in
                    DataRowCellView(dataRow: item)
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: move)
            }
            Section {
                Button {
                    addItem()
                } label: {
                    Label("Add Row", systemImage:"plus.circle")
                }
            }
        }
        .listStyle(.insetGrouped)
        .buttonStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Data Tracker")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("New") {
                    newDataTrack()
                }
                Spacer()
                Button {
                    undoManager?.undo()
                    save()
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                }.disabled(undoDisabled)
                Button {
                    undoManager?.redo()
                    save()
                } label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                }.disabled(redoDisabled)
            }
        }
        .onAppear {
            if dataTrack.first == nil {
                newDataTrack()
            }
            viewContext.undoManager = undoManager
        }
        .onReceive(undoObservers) { _ in
            undoDisabled = undoManager?.canUndo == false
            redoDisabled = undoManager?.canRedo == false
        }
    }

    private func newDataTrack() {
        withAnimation {
            let newDataTrack = DataTrack(context: viewContext)
            let date = Date()
            newDataTrack.timestamp = date
            newDataTrack.name = "Data Track: \(itemFormatter.string(from: date))"
            
            let newItem = DataRow(context: viewContext)
            newItem.timestamp = Date()
            newDataTrack.add(dataRow: newItem)
            
            save()
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = DataRow(context: viewContext)
            newItem.timestamp = Date()
            newItem.order = Int32(dataTrack.first?.dataRows?.count ?? 0)
            dataTrack.first?.add(dataRow: newItem)
            save()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { dataTrack.first!.dataRowsArray[$0] }.forEach(viewContext.delete)
            save()
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var revisedItemOrder = dataTrack.first!.dataRowsArray
        revisedItemOrder.move(fromOffsets: source, toOffset: destination)
        
        for reverseIndex in stride(from: revisedItemOrder.count - 1,
                                   through: 0,
                                   by: -1) {
            revisedItemOrder[reverseIndex].order = Int32(reverseIndex)
        }
        
        save()
    }
    
    private func save() {
        print("saving!")
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DataTrackView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

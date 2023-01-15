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
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @FetchRequest(fetchRequest: DataTrack.latestDataTrackRequest,
                  animation: .default)
    private var dataTrackResult: FetchedResults<DataTrack>
    
    var dataTrack: DataTrack? {
        dataTrackResult.first
    }
    
    private let undoObservers = Publishers.Merge3(NotificationCenter.default.publisher(for: .NSUndoManagerDidCloseUndoGroup),
                                                  NotificationCenter.default.publisher(for: .NSUndoManagerDidUndoChange),
                                                  NotificationCenter.default.publisher(for: .NSUndoManagerDidRedoChange))
    
    @State var undoDisabled: Bool = true
    @State var redoDisabled: Bool = true
    
    private var gridColumns: [GridItem] {
        sizeClass == .compact ? [GridItem(.flexible())]: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    }
    
    private var isCompact: Bool {
        sizeClass == .compact
    }
    
    @State var selectedItem: DataRow?
    @State var hasChangedLocation: Bool = false
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: gridColumns, alignment: .center, spacing: 20) {
                ForEach(dataTrack?.dataRowsArray ?? []) { item in
                    DataRowCellView(dataRow: item, textViewDisabled: $hasChangedLocation)
                        .padding([.leading, .trailing, .bottom])
                        .padding([.top], 8)
                        .overlay(alignment: .topTrailing) {
                            Button {
                                deleteItem(item)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 25))
                                    .offset(x: 12, y: -12)
                            }
                            .scaleEffect(editMode.isEditing ? 1: 0.8)
                            .animation(.spring(response: 0.5, dampingFraction: 0.4), value: editMode)
                            .disabled(!editMode.isEditing)
                            .opacity(editMode.isEditing ? 1: 0)
                        }
                        .background(
                            RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                            .fill(Color(uiColor: .tertiarySystemBackground))
                        )
                        .opacity(selectedItem == item && hasChangedLocation ? 0 : 1)
                        .onDrag {
                            selectedItem = item
                            return NSItemProvider(object: String(item.id?.uuidString ?? "") as NSString)
                        }
                        .onDrop(of: [.text],
                                delegate: DataTrackDropDelegate(selectedItem: $selectedItem,
                                                                hasChangedLocation: $hasChangedLocation,
                                                                dataTrack: dataTrack!,
                                                                item: item) {
                            save()
                        })
                }
                .animation(.default, value: hasChangedLocation)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
//        .onDrop(of: [.text], delegate: DataTrackDropOutsideDelegate(selectedItem: $selectedItem, hasChangedLocation: $hasChangedLocation))
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Data Tracker")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    addItem()
                } label: {
                    Label("Add Row", systemImage:"plus")
                        .symbolRenderingMode(.hierarchical)
                }

                EditButton()
                    .environment(\.editMode, $editMode)
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Clear") {
                    resetTrack()
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
        .task {
            if dataTrack == nil {
                newDataTrack()
            }
        }
        .onAppear {
            viewContext.undoManager = undoManager
        }
        .onReceive(undoObservers) { _ in
            undoDisabled = undoManager?.canUndo == false
            redoDisabled = undoManager?.canRedo == false
        }
    }

    private func resetTrack() {
        if let dataTrack = dataTrack {
            viewContext.delete(dataTrack)
        }
        
        newDataTrack()
    }
    
    private func newDataTrack() {
        withAnimation {
            let newDataTrack = DataTrack(context: viewContext)
            let date = Date()
            newDataTrack.timestamp = date
            newDataTrack.name = "Data Track: \(itemFormatter.string(from: date))"
            
            let newItem = DataRow(context: viewContext)
            newItem.timestamp = Date()
            newItem.id = UUID()
            newDataTrack.add(dataRow: newItem)
            
            save()
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = DataRow(context: viewContext)
            newItem.timestamp = Date()
            newItem.order = dataTrack!.maxOrder + 1
            newItem.id = UUID()
            dataTrack?.add(dataRow: newItem)
            save()
        }
    }

    private func deleteItem(_ item: NSManagedObject) {
        withAnimation {
            viewContext.delete(item)
            save()
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var revisedItemOrder = dataTrack!.dataRowsArray
        revisedItemOrder.move(fromOffsets: source, toOffset: destination)
        
        for reverseIndex in stride(from: revisedItemOrder.count - 1,
                                   through: 0,
                                   by: -1) {
            revisedItemOrder[reverseIndex].order = Int32(reverseIndex)
        }
        
        save()
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Unused Methods -
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { dataTrack!.dataRowsArray[$0] }.forEach(viewContext.delete)
            save()
        }
    }
}

struct DataTrackDropOutsideDelegate: DropDelegate {
    @Binding var selectedItem: DataRow?
    @Binding var hasChangedLocation: Bool

    func dropEntered(info: DropInfo) {
        hasChangedLocation = true
    }
    
    func performDrop(info: DropInfo) -> Bool {
        hasChangedLocation = false
        selectedItem = nil
        return true
    }
}

@MainActor struct DataTrackDropDelegate: DropDelegate {
    @Binding var selectedItem: DataRow?
    @Binding var hasChangedLocation: Bool
    
    var dataTrack: DataTrack
    var item: DataRow
    
    var completion: () -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        selectedItem = nil
        hasChangedLocation = false
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if selectedItem == nil {
            selectedItem = item
        }
        
        hasChangedLocation = true
        
        if selectedItem != item {
            let source = Int(selectedItem!.order)
            var toIndex = Int(item.order)
            
            if toIndex > source {
                toIndex += 1
            }
            
            withAnimation {
                move(from: IndexSet(integer: source), to: toIndex)
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    
    func move(from source: IndexSet, to destination: Int) {
        var revisedItemOrder = dataTrack.dataRowsArray
        
        revisedItemOrder.move(fromOffsets: source, toOffset: destination)
        
        for reverseIndex in stride(from: revisedItemOrder.count - 1,
                                   through: 0,
                                   by: -1) {
            revisedItemOrder[reverseIndex].order = Int32(reverseIndex)
        }
       
        completion()
    }
}

// MARK: - Formatters
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DataTrackView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

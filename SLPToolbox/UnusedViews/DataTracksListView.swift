//
//  DataTracksListView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/16/22.
//

import SwiftUI

struct DataTracksListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedTrack: DataTrack?
    var dismiss: (() -> Void)? = nil
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DataTrack.timestamp, ascending: false)])
    var tracks: FetchedResults<DataTrack>
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tracks) { track in
                    Button {
                        selectedTrack = track
                        dismiss?()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(track.name ?? "Some Track")
                            Text(track.timestamp ?? .now, formatter: dateFormatter)
                        }
                    }
                }.onDelete(perform: deleteItems)
            }
            .navigationTitle("Data Tracks")
            .toolbar {
                if dismiss != nil {
                    ToolbarItem {
                        Button {
                            dismiss?()
                        } label: {
                            Image(systemName: "xmark")
                        }

                    }
                }
        }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { tracks[$0] }.forEach(viewContext.delete)
            save()
        }
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
}

private let dateFormatter: DateFormatter = {
    $0.dateStyle = .medium
    $0.timeStyle = .short
    return $0
}(DateFormatter())

struct DataTracksView_Previews: PreviewProvider {
    static var previews: some View {
        DataTracksListView(selectedTrack: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

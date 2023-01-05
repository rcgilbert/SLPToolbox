//
//  AgeCalculatorView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/22/22.
//

import SwiftUI

struct AgeCalculatorView: View {
    @State var selectedDate: Date = .now
    @State var birthDate: Date = .distantFuture
    
    private let dateComponentsFormatter: DateComponentsFormatter = {
        $0.unitsStyle = .full
        $0.allowedUnits = [.year, .month, .day]
        $0.zeroFormattingBehavior = .dropLeading
        return $0
    }(DateComponentsFormatter())
    
    func clear() {
        selectedDate = .now
        birthDate = .distantFuture
    }
    
    var body: some View {
        Form {
            Section("") {
                DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                DatePicker("Birth Date", selection: $birthDate, in: ...selectedDate, displayedComponents: [.date])
            }
          
            Section("Age") {
                if birthDate <= selectedDate {
                    Text(Calendar.current.dateComponents([.year, .month, .day],
                                                         from: birthDate,
                                                         to: selectedDate),
                         formatter: dateComponentsFormatter)
                    .font(.title2)
                    .textSelection(.enabled)
                    .padding()
                } else {
                    Text("Select Birth Date")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.secondary)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Clear") {
                    withAnimation {
                        clear()
                    }
                }
            }
        }
    }
    
    
}

struct AgeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AgeCalculatorView()
        }
    }
}

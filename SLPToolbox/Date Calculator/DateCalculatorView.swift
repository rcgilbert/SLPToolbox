//
//  DateCalculatorView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/22/22.
//

import SwiftUI

struct DateCalculatorView: View {
    @State var selectedDate: Date = .now
    @State var numberOfDays: Int?
    @FocusState private var numDaysIsFocused: Bool
    
    var futureDate: Date {
        var dayComponents = DateComponents()
        dayComponents.day = numberOfDays ?? 0
        return Calendar.current
            .date(byAdding: dayComponents, to: selectedDate) ?? Date(timeIntervalSinceNow: Double(numberOfDays ?? 0)*3600*24)
    }
    
    var body: some View {
        Form {
            Section("") {
                DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                    .fontWeight(.medium)
                HStack(spacing: 16) {
                    Text("Days from Date")
                        .fontWeight(.medium)
                    Spacer()
                    TextField(value: $numberOfDays, format: .number) {
                        Text("# Days")
                    }
                    .focused($numDaysIsFocused)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .scrollDismissesKeyboard(.immediately)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 75)
                }
            }
            Section("Future Date") {
                if numberOfDays != nil {
                    Text(futureDate.formatted(date: .complete, time: .omitted))
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .textSelection(.enabled)
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    HStack {
                        Spacer()
                        Text("Enter Days from Date")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .padding()
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    withAnimation {
                        numberOfDays = nil
                    }
                } label: {
                    Text("Clear")
                }
            }
        }
        .onTapGesture {
            numDaysIsFocused = false
        }
    }
}

struct DateCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        DateCalculatorView()
    }
}

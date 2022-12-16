//
//  HelperExtensions.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import Foundation
import CoreData

extension Session {
    static var latestSessionRequest: NSFetchRequest<Session> {
        let request = Session.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.timestamp, ascending: false)]
        return request
    }
    
    var patientsArray: [Patient] {
        let patientSet = self.patients as? Set<Patient> ?? .init()
        return patientSet.sorted(by: { $0.order == $1.order ? $0.timestamp! < $1.timestamp! : $0.order < $1.order })
    }
    
    func add(patient: Patient) {
        var patientSet = patients as? Set<Patient> ?? .init()
        patientSet.insert(patient)
        patients = patientSet as NSSet
    }
}

extension Patient {
    var total: Int {
        Int(incorrectCount + correctCount)
    }
    
    var totalString: String {
        countFormatter.string(for: total) ?? "-"
    }
    
    var percentageCorrect: Double {
        if total == 0 {
            return 1.0
        }
        
        return Double(correctCount) / Double(total)
    }
    
    var percentageCorrectString: String {
        percentageFormatter.string(for: percentageCorrect) ?? "N/A %"
    }
    
    var correctCountString: String {
        countFormatter.string(for: correctCount) ?? "-"
    }
    
    var wrappedName: String {
        get {
            name ?? ""
        }
        set {
            name = newValue
        }
    }
    
}

let countFormatter: NumberFormatter = NumberFormatter()

let percentageFormatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.numberStyle = .percent
    return nf
}()


//
//  HelperExtensions.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import Foundation
import CoreData

extension DataTrack {
    static var latestDataTrackRequest: NSFetchRequest<DataTrack> {
        let request = DataTrack.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DataTrack.timestamp, ascending: false)]
        return request
    }
    
    var dataRowsArray: [DataRow] {
        let dataSet = self.dataRows as? Set<DataRow> ?? .init()
        return dataSet.sorted(by: { $0.order == $1.order ? $0.timestamp! < $1.timestamp! : $0.order < $1.order })
    }
    
    var maxOrder: Int32 {
        dataRowsArray.last?.order ?? -1
    }
    
    func add(dataRow: DataRow) {
        var dataSet = dataRows as? Set<DataRow> ?? .init()
        dataSet.insert(dataRow)
        dataRows = dataSet as NSSet
    }

}

extension Bundle {
    var versionString: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumberString: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension DataRow {
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


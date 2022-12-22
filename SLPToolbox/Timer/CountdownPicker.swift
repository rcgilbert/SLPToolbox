//
//  CountdownPicker.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/19/22.
//

import SwiftUI
import UIKit

// MARK: - CountdownPickerView

final class CountdownPickerView: UIPickerView {
    lazy var hourLabel: UILabel = UILabel()
    lazy var minuteLabel: UILabel = UILabel()
    lazy var secondLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hourLabel)
        addSubview(minuteLabel)
        addSubview(secondLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(hourLabel)
        addSubview(minuteLabel)
        addSubview(secondLabel)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        configureUnitLabels()
    }
    
    private func configureUnitLabels() {
        let rowWidth = rowSize(forComponent: 0).width
        let outsideLeadingPadding: CGFloat = 9.0 // Found from inspecting picker view
        let outsideTrailingPadding: CGFloat = 9.0
        let spacing = (bounds.width - outsideLeadingPadding - outsideTrailingPadding - (rowWidth * CGFloat(numberOfComponents))) / CGFloat(numberOfComponents - 1)

        hourLabel.frame = CGRect(x: outsideLeadingPadding + (rowWidth / 2.0) + 8, y: 0, width: 0, height: 0)
        updateUnitLabels(for: 0, in: 0)
        hourLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        hourLabel.textAlignment = .left
        hourLabel.sizeToFit()
        hourLabel.center = CGPoint(x: hourLabel.center.x, y: center.y)
        
        
        minuteLabel.frame = CGRect(x: outsideLeadingPadding + (1.5 * rowWidth) + spacing + 8, y: 0, width: 0, height: 0)
        updateUnitLabels(for: 0, in: 1)
        minuteLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        minuteLabel.textAlignment = .left
        minuteLabel.sizeToFit()
        minuteLabel.center = CGPoint(x: minuteLabel.center.x, y: center.y)

        secondLabel.frame = CGRect(x: outsideLeadingPadding + (2.5 * rowWidth) + (2 * spacing) + 8, y: 0, width: 0, height: 0)
        updateUnitLabels(for: 0, in: 2)
        secondLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        secondLabel.textAlignment = .left
        secondLabel.sizeToFit()
        secondLabel.center = CGPoint(x: secondLabel.center.x, y: center.y)
    }
    
    func updateUnitLabels(for row: Int, `in` component: Int) {
        switch component {
        case 0:
            hourLabel.text = row == 0 || row > 1 ? String(localized: "hours"): String(localized: "hour")
        case 1:
            minuteLabel.text = String(localized: "min")
        case 2:
            secondLabel.text = String(localized: "sec")
        default:
            break
        }
       
    }
}

// MARK: - PickerCell

fileprivate final class PickerCell: UIView {
    var titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.font = UIFont.preferredFont(forTextStyle: .title3)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
    }
}

// MARK: - CountdownPicker

struct CountdownPicker: UIViewRepresentable {
    @Binding var duration: TimeInterval
    
    func makeUIView(context: Context) -> CountdownPickerView {
        let pickerView = CountdownPickerView()
        pickerView.dataSource = context.coordinator
        pickerView.delegate = context.coordinator
        pickerView.setNeedsUpdateConstraints()
        return pickerView
    }
    
    func updateUIView(_ pickerView: CountdownPickerView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let parent: CountdownPicker
        
        private let pickerData = [Array(0..<24), Array(0..<60), Array(0..<60)]
        
        init(parent: CountdownPicker) {
            self.parent = parent
        }
        
        // MARK: UIPickerViewDataSource | UIPickerViewDelegate
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0:
                return 24
            case 1:
                return 60
            case 2:
                return 60
            default:
                return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let cell = view as? PickerCell ?? PickerCell()
            cell.titleLabel.text = "\(pickerData[component][row])"
            cell.titleLabel.sizeToFit()
            return cell
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let hourIndex = pickerView.selectedRow(inComponent: 0)
            let minuteIndex = pickerView.selectedRow(inComponent: 1)
            let secondIndex = pickerView.selectedRow(inComponent: 2)
            
            parent.duration = TimeInterval(pickerData[0][hourIndex]*60*60 + pickerData[1][minuteIndex]*60 + pickerData[2][secondIndex])
            
            if let countdownPicker = pickerView as? CountdownPickerView {
                countdownPicker.updateUnitLabels(for: row, in: component)
            }
        }
    }
}

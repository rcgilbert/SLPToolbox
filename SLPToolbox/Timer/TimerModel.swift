//
//  TimerModel.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/22/22.
//

import Foundation
import SwiftUI
import UserNotifications
 
@MainActor final class TimerModel: ObservableObject {
    enum TimerState: Codable {
        case inactive
        case running(endDate: Date)
        case paused(timeRemaining: TimeInterval)
        case ended(endDate: Date)
    }
    
    public static let NotificationID = "SLPToolbox.Timer"
    public static let NotificationEndDateUserInfoKey = "Timer.EndDate"
    
    @StoredCodable(key: "TimerModel.TimerState", defaultValue: .inactive) var timerState: TimerState
    
    private var timer: Timer?
    
    init() {
        if case let .running(endDate) = timerState, endDate < .now {
            end()
        }
        updateTimer()
    }
    
    func start(withDuration duration: TimeInterval) {
        timerState = .running(endDate: .init(timeIntervalSinceNow: duration))
        
        scheduleTimerNotication()
        updateLiveActivity()
        updateTimer()
    }
    
    func resume() {
        guard case let .paused(timerRemaining) = timerState else {
            return
        }
        
        timerState = .running(endDate: .init(timeIntervalSinceNow: timerRemaining))
        
        scheduleTimerNotication()
        updateLiveActivity()
        updateTimer()
    }
    
    func pause() {
        guard case let .running(endDate) = timerState else {
            return
        }
        
        timerState = .paused(timeRemaining: endDate.timeIntervalSinceNow)
        
        removeTimerNotification()
        updateLiveActivity()
        updateTimer()
    }
    
    @objc func end() {
        guard case let .running(endDate) = timerState, endDate <= .now else {
            return
        }
        
        timerState = .ended(endDate: endDate)
        
        removeTimerNotification()
        updateLiveActivity()
        updateTimer()
    }
    
    func cancel() {
        timerState = .inactive
        
        removeTimerNotification()
        updateLiveActivity()
        updateTimer()
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .criticalAlert]) { granted, error in
            // Add state for permissions are not granted
        }
    }
    
    private func scheduleTimerNotication() {
        guard case let .running(endDate) = timerState else {
            return
        }
        
        removeTimerNotification()
        
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished!"
        content.body = "Your timer has completed."
        content.categoryIdentifier = "SLPToolbox.Timer.CountdownComplete"
        content.sound = UNNotificationSound.defaultCritical
        content.interruptionLevel = .critical
        content.userInfo = [Self.NotificationEndDateUserInfoKey: endDate]
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: endDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: Self.NotificationID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func removeTimerNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Self.NotificationID])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [Self.NotificationID])
    }
    
    private func updateTimer() {
        switch timerState {
        case .inactive:
            timer?.invalidate()
            timer = nil
        case .running(let endDate):
            let t = Timer(fireAt: endDate, interval: 0, target: self, selector: #selector(end), userInfo: nil, repeats: false)
            timer = t
            RunLoop.main.add(t, forMode: .default)
        case .paused:
            timer?.invalidate()
            timer = nil
        case .ended:
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func updateLiveActivity() {
//        switch timerState {
//        case .inactive:
//            break
//        case .running(let endDate):
//            break
//        case .paused(let timeRemaining):
//            break
//        case .ended(let endDate):
//            break
//        }
    }
}

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
    enum TimerState {
        case inactive
        case running(endDate: Date)
        case paused(timeRemaining: TimeInterval)
        case ended(endDate: Date)
    }
    
    public static let NotificationID = "SLPToolbox.Timer"
    public static let NotificationEndDateUserInfoKey = "Timer.EndDate"
    
    @Published var timerState: TimerState = .inactive
    
    func start(withDuration duration: TimeInterval) {
        timerState = .running(endDate: .init(timeIntervalSinceNow: duration))
        
        scheduleTimerNotication()
    }
    
    func resume() {
        guard case let .paused(timerRemaining) = timerState else {
            return
        }
        
        timerState = .running(endDate: .init(timeIntervalSinceNow: timerRemaining))
        
        scheduleTimerNotication()
    }
    
    func pause() {
        guard case let .running(endDate) = timerState else {
            return
        }
        
        timerState = .paused(timeRemaining: endDate.timeIntervalSinceNow)
        
        removeTimerNotification()
    }
    
    func cancel() {
        timerState = .inactive
        
        removeTimerNotification()
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .criticalAlert]) { granted, error in
            if granted {
                print("Granted!")
            }
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
}

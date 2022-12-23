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
    @Published var isTimerRunning: Bool = false
    @Published var isTimerEnded: Bool = false
    @Published var isTimerPaused: Bool = false
    @Published var endDate: Date = .distantFuture
    @Published var timeRemaining: TimeInterval = 0
    @Published var startDate: Date = .now
    
    private var updateTimer: Timer?
    
    private let notificationID = "SLPToolbox.Timer"
    
    func start() {
        startDate = .now
        endDate = Date.now.addingTimeInterval(timeRemaining)
        isTimerRunning = true
        isTimerPaused = false
        
        scheduleTimerNotication()
        updateTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(didUpdate), userInfo: nil, repeats: true)
    }
    
    func resume() {
        endDate = Date.now.addingTimeInterval(timeRemaining)
        isTimerRunning = true
        isTimerPaused = false
        
        scheduleTimerNotication()
        updateTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(didUpdate), userInfo: nil, repeats: true)
    }
    
    func pause() {
        timeRemaining = endDate.timeIntervalSinceNow
        isTimerPaused = true
        
        removeTimerNotification()
        updateTimer?.invalidate()
    }
    
    func stop() {
        isTimerRunning = false
        isTimerEnded = false
        isTimerPaused = false
        timeRemaining = 0
        endDate = .now
        
        removeTimerNotification()
        updateTimer?.invalidate()
    }
    
    @objc private func didUpdate(_ timer: Timer) {
        guard isTimerRunning, !isTimerPaused, !isTimerEnded else {
            timer.invalidate()
            return
        }
        
        timeRemaining = endDate.timeIntervalSinceNow
        isTimerEnded = timeRemaining <= 0
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .criticalAlert]) { granted, error in
            if granted {
                print("Granted!")
            }
        }
    }
    
    private func scheduleTimerNotication() {
        removeTimerNotification()
        
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished!"
        content.body = "Your timer has completed."
        content.categoryIdentifier = "SLPToolbox.Timer.CountdownComplete"
        content.sound = UNNotificationSound.defaultCritical
        content.interruptionLevel = .critical
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: endDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func removeTimerNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationID])
    }
}

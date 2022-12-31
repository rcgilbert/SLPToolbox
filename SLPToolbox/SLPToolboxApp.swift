//
//  SLPToolboxApp.swift
//  SimpleTx
//
//  Created by Ryan Gilbert on 12/12/22.
//

import SwiftUI
import UserNotifications

@main
struct SLPToolboxApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    let persistenceController = PersistenceController.shared
    var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        AppState.shared.loadSelectedScreen()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AppState.shared.saveSelectedScreen()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        if notification.request.identifier == TimerModel.NotificationID,
           let endDate = notification.request.content.userInfo[TimerModel.NotificationEndDateUserInfoKey] as? Date {
            withAnimation {
                AppState.shared.timerModel.timerState = .ended(endDate: endDate)
            }
           
        }
        return [.banner, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == TimerModel.NotificationID,
           let endDate = response.notification.request.content.userInfo[TimerModel.NotificationEndDateUserInfoKey] as? Date {
            withAnimation {
                AppState.shared.timerModel.timerState = .ended(endDate: endDate)
            }
            
            AppState.shared.selectedScreen = .timer
        }
        completionHandler()
    }
}

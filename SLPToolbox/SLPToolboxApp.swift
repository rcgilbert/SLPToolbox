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
                .onOpenURL { url in
                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                          let host = components.host,
                          let screen = AppScreen(rawValue: host) else {
                        return
                    }
                    appState.selectedScreen = screen
                    
                    switch screen {
                    case .dataTracker:
                        break
                    case .timer:
                        if components.queryItems?
                            .contains(where: { $0.name == "action" && $0.value == "cancel"}) == true {
                            appState.timerModel.cancel()
                        }
                    case .ageCalculator:
                        break
                    case .dateCalculator:
                        break
                    case .settings:
                        break
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
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

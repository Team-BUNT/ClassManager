//
//  ClassManagerApp.swift
//  ClassManager
//
//  Created by GOngTAE on 2022/10/12.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct ClassManagerApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("onboarding") var isOnboardingActive: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingActive {
                OnboardingMain()
            } else {
                NavigationView {
                    ClassCalendarView()
                }
            }
        }
    }
}

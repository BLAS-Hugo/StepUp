//
//  StepUpApp.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)

    FirebaseApp.configure()
    return true
  }
}

@main
struct StepUpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var authenticationService = AuthenticationService()
    @StateObject var healthKitService = HealthKitService()
    @StateObject var objectivesViewModel = ObjectivesViewModel()

    var body: some Scene {
        WindowGroup {
            if authenticationService.currentUserSession != nil {
                AppMainView()
                    .environmentObject(authenticationService)
                    .environmentObject(UserChallengesService(with: authenticationService, healthKitService))
                    .environmentObject(healthKitService)
                    .environmentObject(objectivesViewModel)
            } else {
                AuthNavigationView().environmentObject(authenticationService)
            }
        }
    }
}

struct AuthNavigationView: View {
    @EnvironmentObject var authenticationService: AuthenticationService

    var body: some View {
        NavigationStack {
            LoginScreen().environmentObject(authenticationService)
        }
    }
}

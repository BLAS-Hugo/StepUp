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

    @StateObject var authenticationService = AuthenticationViewModel(authProvider: FirebaseAuthProvider())
    @StateObject var healthKitService = HealthKitService()
    @StateObject var goalViewModel = GoalViewModel()

    var body: some Scene {
        WindowGroup {
            // Show loading state while determining authentication status
            if !authenticationService.isInitialized {
                LoadingView()
            } else if authenticationService.isAuthenticated {
                AppMainView()
                    .environmentObject(authenticationService)
                    .environmentObject(
                        UserChallengesService(
                            with: authenticationService,
                            healthKitService,
                            challengeStore: FirestoreChallengeStore()
                        ))
                    .environmentObject(healthKitService)
                    .environmentObject(goalViewModel)
            } else {
                AuthNavigationView().environmentObject(authenticationService)
            }
        }
    }
}

struct AuthNavigationView: View {
    @EnvironmentObject var authenticationService: AuthenticationViewModel

    var body: some View {
        NavigationStack {
            LoginScreen().environmentObject(authenticationService)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .padding(.top)
        }
    }
}

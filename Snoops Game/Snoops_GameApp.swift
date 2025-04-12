import SwiftUI

@main
struct Snoops_GameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let currentScreen = NavGuard.shared.currentScreen
        if currentScreen == .PLEASURE {
            return .allButUpsideDown
        } else {
            return .landscape
        }
    }
}

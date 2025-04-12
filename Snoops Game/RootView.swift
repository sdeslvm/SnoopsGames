import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var nav: NavGuard = NavGuard.shared
    var body: some View {
        switch nav.currentScreen {
                                        
        case .MENU:
            MenuView()
            
        case .LOADING:
            LoadingScreen()
            
        case .SETTINGS:
            SettingsView()
            
        case .RULES:
            RulesView()
            
        case .BONUS:
            BonusView()
            
        case .SHOP:
            ShopView()
            
        case .GAMELEVEL:
            GameLevel()
            
        case .LEVELS:
            LevelsView()
            
        case .PLEASURE:
            if let url = URL(string: urlForValidation) {
                BrowserView(pageURL: url)
                    .onAppear {
                        print("BrowserView appeared")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                    }
            } else {
                Text("Invalid URL")
            }
        }

    }
}

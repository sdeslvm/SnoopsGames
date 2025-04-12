import Foundation


enum AvailableScreens {
    case MENU
    case LOADING
    case PLEASURE
    case SETTINGS
    case RULES
    case BONUS
    case SHOP
    case GAMELEVEL
    case LEVELS
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    static var shared: NavGuard = .init()
}

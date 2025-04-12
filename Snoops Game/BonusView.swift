import SwiftUI

struct BonusView: View {
    @State private var showAlert = false // Флаг для показа алерта
    @State private var alertMessage = "" // Сообщение в алерте
    
    @AppStorage("bush1LastClicked") private var bush1LastClicked: Int = 0 // Время в секундах
    @AppStorage("bush2LastClicked") private var bush2LastClicked: Int = 0
    @AppStorage("bush3LastClicked") private var bush3LastClicked: Int = 0
    @AppStorage("bush4LastClicked") private var bush4LastClicked: Int = 0
    @AppStorage("bush5LastClicked") private var bush5LastClicked: Int = 0
    
    @AppStorage("lastBushOpened") private var lastBushOpened: Int = 0 // Время последнего открытия любого куста

    private let bushes: [String] = ["bush", "bush", "bush", "bush", "bush"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.top, 10)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                        Spacer()
                    }
                    Spacer()
                }
                
                ZStack {
                    VStack {
                        HStack {
                            ForEach(0..<3) { index in
                                bushView(index: index)
                            }
                        }
                        HStack {
                            ForEach(3..<5) { index in
                                bushView(index: index)
                            }
                        }
                    }
                    .padding(.top, 50)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("backgroundBonus")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations!"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    NavGuard.shared.currentScreen = .MENU
                })
            }
        }
    }
    
    @ViewBuilder
    func bushView(index: Int) -> some View {
        let lastClickedTime: Int
        switch index {
        case 0: lastClickedTime = bush1LastClicked
        case 1: lastClickedTime = bush2LastClicked
        case 2: lastClickedTime = bush3LastClicked
        case 3: lastClickedTime = bush4LastClicked
        case 4: lastClickedTime = bush5LastClicked
        default: lastClickedTime = 0
        }
        
        return Image(bushes[index])
            .resizable()
            .scaledToFit()
            .frame(width: 170, height: 170)
            .onTapGesture {
                handleBushTap(index: index, lastClickedTime: lastClickedTime)
            }
    }
    
    func handleBushTap(index: Int, lastClickedTime: Int) {
        let currentTime = Int(Date().timeIntervalSince1970) // Текущее время в секундах
        let secondsIn24Hours = 24 * 60 * 60 // 24 часа в секундах
        
        let secondsSinceLastOpen = currentTime - lastBushOpened
        let hoursPassedSinceLastOpen = secondsSinceLastOpen / 3600 // Часы с последнего открытия любого куста
        
        if hoursPassedSinceLastOpen >= 24 || lastBushOpened == 0 {
            // Проверяем, прошло ли более 24 часов с момента последнего открытия любого куста
            let secondsSinceThisBush = currentTime - lastClickedTime
            let hoursPassedForThisBush = secondsSinceThisBush / 3600 // Часы с последнего клика по этому кусту
            
            if hoursPassedForThisBush >= 24 || lastClickedTime == 0 {
                // Если прошло более 24 часов для конкретного куста
                alertMessage = "You won 50 coins!"
                showAlert = true
                
                // Обновляем время последнего клика для этого куста и общее время
                updateLastClickedTime(for: index)
                lastBushOpened = Int(Date().timeIntervalSince1970)
            } else {
                // Если для этого куста еще не прошло 24 часа
                let remainingHours = 24 - hoursPassedForThisBush
                alertMessage = "You can open this bush again in \(remainingHours) hour(s)."
                showAlert = true
            }
        } else {
            // Если любой куст уже был открыт менее 24 часов назад
            let remainingHours = 24 - hoursPassedSinceLastOpen
            alertMessage = "You can open any bush again in \(remainingHours) hour(s)."
            showAlert = true
        }
    }
    
    func updateLastClickedTime(for index: Int) {
        let currentTime = Int(Date().timeIntervalSince1970)
        switch index {
        case 0: bush1LastClicked = currentTime
        case 1: bush2LastClicked = currentTime
        case 2: bush3LastClicked = currentTime
        case 3: bush4LastClicked = currentTime
        case 4: bush5LastClicked = currentTime
        default: break
        }
    }
}


#Preview {
    BonusView()
}

import SwiftUI

struct MenuView: View {
    @AppStorage("firstOpen") var firstOpen = false
    @StateObject private var soundManager = CheckingSound()
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard1: String = "raper1" // Новая переменная для хранения closeImage выбранной карты
    @AppStorage("lastBushOpened") private var lastBushOpened: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                    ZStack {
                        Image(currentSelectedCloseCard1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 250)
                        
                        VStack {
                            HStack {
                                StarTemplate()
                                BalanceTemplate()
                                Spacer()
                                ButtonTemplateSmall(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .SETTINGS})
                                    .padding()
                            }
                            Spacer()
                            
                            HStack {
                                ButtonTemplateSmall(image: "shopBtn", action: {NavGuard.shared.currentScreen = .SHOP})
                                Spacer()
                                ButtonTemplateSmall(image: "rulesBtn", action: {NavGuard.shared.currentScreen = .RULES})

                            }
                        }
                        
                        HStack {
                            Spacer()
                            if lastBushOpened == 0 {
                                ButtonTemplateSmall(image: "bonusBtn", action: {NavGuard.shared.currentScreen = .BONUS})
                            } else {
//                                ButtonTemplateSmall(image: "bonusBtn", action: {NavGuard.shared.currentScreen = .MENU})
                            }
                            
                        }
                        
                        if firstOpen {
                            ButtonTemplateBig(image: "startBtn", action: {NavGuard.shared.currentScreen = .LEVELS})
                                .padding(.top, 40)
                        } else {
                            ButtonTemplateBig(image: "startBtn", action: {clickRight()})
                                .padding(.top, 40)
                        }
                        
                            
                        }
                    .onAppear {
                        if isFirstLaunch {
                            soundManager.musicEnabled = true
                            isFirstLaunch = false // Отмечаем, что первый запуск прошёл
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    

            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )


        }
    }
    func clickRight() {
        firstOpen = true
        NavGuard.shared.currentScreen = .MENU
    }
}




struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    var body: some View {
            ZStack {
                Image(.balanceTemplate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 70)
                    .overlay(
                        ZStack {
                            Text("\(coinscore)")
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                                .font(.title3)
                                .position(x: 100, y: 30)
                            
                        }
                    )
            }
    }
}

struct StarTemplate: View {
    @AppStorage("starscore") var starscore: Int = 10
    var body: some View {
        ZStack {
            Image(.eggTemplate)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                            Text("\(starscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 80, y: 40)
                        
                    }
                )
        }
    }
}


struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 140)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}


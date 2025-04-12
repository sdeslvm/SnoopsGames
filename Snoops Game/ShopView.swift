import SwiftUI

// Модель данных для карты
struct CardOption: Identifiable {
    let id: String
    let buyImage: String
    let selectImage: String
    let closeImage: String
    let selectedImage: String
}

// Первая страница магазина
struct ShopPageOne: View {
    @Binding var playerBalance: Int

    @AppStorage("ownedCards1") private var ownedCards1: String = "bush" // Начальное значение
    @AppStorage("selectedCard1") private var selectedCard1: String = "firstCardSelected"
    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard1: String = "raper1"

    @State private var alertMessage: String?
    @State private var showAlert: Bool = false

    
    
    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard", buyImage: "firstCardBuy", selectImage: "firstCardSelect", closeImage: "raper1", selectedImage: "firstCardSelected"),
        CardOption(id: "secondCard", buyImage: "secondCardBuy", selectImage: "secondCardSelect", closeImage: "raper2", selectedImage: "secondCardSelected"),
        CardOption(id: "thirdCard", buyImage: "thirdCardBuy", selectImage: "thirdCardSelect", closeImage: "raper3", selectedImage: "thirdCardSelected")
    ]

    private let cardPrice: Int = 10

    var body: some View {
        HStack(spacing: 20) {
            ForEach(cardOptions) { card in
                Button(action: {
                    print("ShopPageOne: Button pressed for \(card.id)")
                    handleCardAction(for: card)
                }) {
                    Image(currentImage(for: card))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 210)
                }
            }
        }
        .onAppear {
            print("ShopPageOne appeared")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard1 {
            return card.selectedImage
        } else if ownedCards1.contains(card.closeImage) {
            return card.selectImage
        } else {
            return card.buyImage
        }
    }

    private func handleCardAction(for card: CardOption) {
        print("ShopPageOne: Handling action for \(card.id), ownedCards: \(ownedCards1), balance: \(playerBalance)")
        if ownedCards1.contains(card.closeImage) {
            selectedCard1 = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage)
            alertMessage = "Card selected successfully!"
        } else if playerBalance >= cardPrice {
            playerBalance -= cardPrice
            ownedCards1 += ownedCards1.isEmpty ? card.closeImage : ",\(card.closeImage)"
            selectedCard1 = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage)
            alertMessage = "Card purchased successfully!"
        } else {
            alertMessage = "Not enough coins to buy this card!"
        }
        showAlert = true
    }

    private func saveCurrentSelectedCloseCard(_ closeCard: String) {
        currentSelectedCloseCard1 = closeCard
    }
}

// Вторая страница магазина
struct ShopPageTwo: View {
    @Binding var playerBalance: Int

    @AppStorage("ownedCards") private var ownedCards: String = "raper1" // Начальное значение
    @AppStorage("selectedCard") private var selectedCard: String = "firstCardSelected"
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard1: String = "bush"

    @State private var alertMessage: String?
    @State private var showAlert: Bool = false

    
    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard1", buyImage: "firstCardBuy1", selectImage: "firstCardSelect1", closeImage: "bush", selectedImage: "firstCardSelected1"),
        CardOption(id: "secondCard1", buyImage: "secondCardBuy1", selectImage: "secondCardSelect1", closeImage: "bush2", selectedImage: "secondCardSelected1"),
        CardOption(id: "thirdCard1", buyImage: "thirdCardBuy1", selectImage: "thirdCardSelect1", closeImage: "bush3", selectedImage: "thirdCardSelected1")
    ]

    private let cardPrice: Int = 10

    var body: some View {
        HStack(spacing: 20) {
            ForEach(cardOptions) { card in
                Button(action: {
                    handleCardAction(for: card)
                }) {
                    Image(currentImage(for: card))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 210)
                }
            }
        }
        .onAppear {
            print("ShopPageTwo appeared")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard {
            return card.selectedImage
        } else if ownedCards.contains(card.closeImage) {
            return card.selectImage
        } else {
            return card.buyImage
        }
    }

    private func handleCardAction(for card: CardOption) {
        
        if ownedCards.contains(card.closeImage) {
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard1(card.closeImage)
            alertMessage = "Card selected successfully!"
        } else if playerBalance >= cardPrice {
            playerBalance -= cardPrice
            ownedCards += ownedCards.isEmpty ? card.closeImage : ",\(card.closeImage)"
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard1(card.closeImage)
            alertMessage = "Card purchased successfully!"
        } else {
            alertMessage = "Not enough coins to buy this card!"
        }
        showAlert = true
    }

    private func saveCurrentSelectedCloseCard1(_ closeCard: String) {
        currentSelectedCloseCard1 = closeCard
        print("ShopPageTwo: Saved currentSelectedCloseCard1: \(currentSelectedCloseCard1)")
    }
}

// Основной экран магазина
struct ShopView: View {
    @State private var currentGroupIndex: Int = 0
    @AppStorage("coinscore") private var playerBalance: Int = 20 // Начальный баланс 20 для теста

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(currentGroupIndex == 0 ? "shopPlate1" : "shopPlate2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 620, height: 520)
                    .overlay(
                        ZStack {
                            Image("close")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .onTapGesture {
                                    NavGuard.shared.currentScreen = .MENU
                                }
                                .position(x: 590, y: 130)
                            HStack {
                                Image(currentGroupIndex == 0 ? "page2On" :  "page2Off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .position(x: 200, y: 160)
                                    .onTapGesture {
                                            currentGroupIndex = max(0, currentGroupIndex - 1)
                                    }
                                
                                Image(currentGroupIndex == 0 ? "page1Off" :  "page1On")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .position(x: 130, y: 160)
                                    .onTapGesture {

                                            currentGroupIndex = min(1, currentGroupIndex + 1)
                                    
                                    }
                                
                            }
                        }
                    )

                VStack {

                    if currentGroupIndex == 0 {
                        ShopPageOne(playerBalance: $playerBalance)
                    } else {
                        ShopPageTwo(playerBalance: $playerBalance)
                    }
                }
                .padding(.top, 80)
                
               
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("backgroundSettings") // Предполагается, что это имя изображения
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
        .onAppear {
            print("ShopView appeared with balance: \(playerBalance)")
        }
    }
}


#Preview {
    ShopView()
}

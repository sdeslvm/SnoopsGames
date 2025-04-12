import SwiftUI

struct GameLevel: View {
    @State private var player1CapPosition: Int? = nil
    @State private var player2CapPosition: Int? = nil
    @State private var currentPlayer: Int = 1
    @State private var shotPosition: Int? = nil
    @State private var showShot: Bool = false
    @State private var shotOffset: CGSize = .zero
    @State private var currentRound: Int = 5
    @State private var gameOver: Bool = false
    @State private var winner: Int? = nil
    @State private var bushesToRemove: Set<Int> = []
    @State private var roundPhase: Int = 0
    @State private var bushPositions: [Int: CGPoint] = [:]

    private let player1BushCounts = [6, 5, 4, 3, 2]
    private let player2BushCounts = [2, 3, 4, 5, 6]
    private let player1Offsets = [0, 6, 11, 15, 18]
    private let player2Offsets = [30, 32, 35, 39, 44]
    private let shotDuration: Double = 2
    
    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard1: String = "raper1"
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "bush"

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Image(.block1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 250)
                        .scaleEffect(x: 1.35, y: 1)
                    Spacer()
                    Image(.block)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 250)
                        .scaleEffect(x: 1.35, y: 1)
                }
                .padding(.horizontal, -50)
                .padding(.top, 50)
                
                
                VStack {
                    HStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                        Spacer()
                    }
                    Spacer()
                }
                
                HStack {
                    Image(currentSelectedCloseCard1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 120)
                        .padding(.leading, -20)
                        .padding(.top, -70)
                    
                    Spacer()
                    
                    Image(.enemy)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 120)
                        .padding(.trailing, -20)
                        .padding(.top, -70)
                }

                PlayerIndicatorView(currentPlayer: currentPlayer)

                ZStack {
                    HStack {
                        ForEach(0..<5, id: \.self) { vStackIndex in
                            VStack {
                                ForEach(0..<player1BushCounts[vStackIndex], id: \.self) { bushIndex in
                                    let globalIndex = calculateGlobalIndex(vStackIndex: vStackIndex, bushIndex: bushIndex, isPlayer1: true)
                                    GeometryReader { bushGeometry in
                                        ZStack {
                                            if bushesToRemove.contains(globalIndex) {
                                                Color.clear
                                            } else {
                                                Image(currentSelectedCloseCard)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                            if player1CapPosition == globalIndex {
                                                Image("cap1")
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }
                                        .frame(width: 50, height: 50)
                                        .onAppear {
                                            let center = bushGeometry.frame(in: .global).center
                                            bushPositions[globalIndex] = center
                                        }
                                    }
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        handleTap(index: globalIndex, isPlayer1: true)
                                    }
                                }
                            }
                            .overlay(
                                ZStack {
                                    vStackIndex == (5 - currentRound) ? RoundedRectangle(cornerRadius: 5).stroke(Color.yellow, lineWidth: 3) : nil
                                }
                                .padding(-10)
                                .padding(.leading, 10)
                            )
                        }
                        Spacer()
                    }
                    .padding(.top, 80)
                    .padding(.leading, 80)

                    // Игрок 2 (справа)
                    HStack {
                        Spacer()
                        ForEach(0..<5, id: \.self) { vStackIndex in
                            VStack {
                                ForEach(0..<player2BushCounts[vStackIndex], id: \.self) { bushIndex in
                                    let globalIndex = calculateGlobalIndex(vStackIndex: vStackIndex, bushIndex: bushIndex, isPlayer1: false)
                                    GeometryReader { bushGeometry in
                                        ZStack {
                                            if bushesToRemove.contains(globalIndex) {
                                                Color.clear
                                            } else {
                                                Image(currentSelectedCloseCard)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }
                                        .frame(width: 50, height: 50)
                                        .onAppear {
                                            let center = bushGeometry.frame(in: .global).center
                                            bushPositions[globalIndex] = center
                                        }
                                    }
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        handleTap(index: globalIndex, isPlayer1: false)
                                    }
                                }
                            }
                            .overlay(
                                ZStack {
                                    vStackIndex == (currentRound - 1) ? RoundedRectangle(cornerRadius: 5).stroke(Color.yellow, lineWidth: 3) : nil
                                }
                                .padding(-10)
                                .padding(.leading, 10)
                            )
                        }
                    }
                    .padding(.top, 80)
                    .padding(.trailing, 80)

                    // Выстрел с анимацией
                    if showShot, let shotPos = shotPosition, let startPos = (currentPlayer == 1 ? player1CapPosition : player2CapPosition) {
                        Image("shot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .position(bushPositions[startPos] ?? .zero) // Начальная позиция выстрела
                            .offset(shotOffset)
                            .zIndex(1)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)

                // Экран победы
                if gameOver, let winner = winner {
                    if winner == 2 {
                        LoseView()
                    } else {
                        WinView()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundGame)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.01)
            )
        }
    }

    // MARK: - Game Logic Methods

    private func calculateGlobalIndex(vStackIndex: Int, bushIndex: Int, isPlayer1: Bool) -> Int {
        if isPlayer1 {
            return player1Offsets[vStackIndex] + bushIndex
        } else {
            return player2Offsets[vStackIndex] + bushIndex
        }
    }

    private func isInCurrentRoundRange(index: Int, isPlayer1: Bool) -> Bool {
        let vStackIndex = isPlayer1 ? (5 - currentRound) : (currentRound - 1)
        let start = isPlayer1 ? player1Offsets[vStackIndex] : player2Offsets[vStackIndex]
        let end = start + (isPlayer1 ? player1BushCounts[vStackIndex] : player2BushCounts[vStackIndex]) - 1
        return index >= start && index <= end
    }

    private func handleTap(index: Int, isPlayer1: Bool) {
        if gameOver { return }

        if roundPhase == 0 { // Фаза размещения кепок
            if currentPlayer == 1 && isPlayer1 && player1CapPosition == nil {
                if isInCurrentRoundRange(index: index, isPlayer1: true) {
                    player1CapPosition = index
                    placeCapForPlayer2()
                    roundPhase = 1
                }
            }
        } else if roundPhase == 1 { // Фаза стрельбы
            if currentPlayer == 1 && !isPlayer1 && !showShot {
                if isInCurrentRoundRange(index: index, isPlayer1: false) {
                    shotPosition = index
                    performShot()
                }
            }
        }
    }

    private func placeCapForPlayer2() {
        let vStackIndex = currentRound - 1
        let start = player2Offsets[vStackIndex]
        let end = start + player2BushCounts[vStackIndex] - 1
        let availableBushes = (start...end).filter { !bushesToRemove.contains($0) }
        if let bush = availableBushes.randomElement() {
            player2CapPosition = bush // Исправлено: не вычитаем 30
        }
    }

    private func performShot() {
        guard let shotPos = shotPosition,
              let startIndex = (currentPlayer == 1 ? player1CapPosition : player2CapPosition),
              let startPoint = bushPositions[startIndex],
              let endPoint = bushPositions[shotPos] else {
            DispatchQueue.main.asyncAfter(deadline: .now() + shotDuration) {
                showShot = false
                checkHit()
            }
            return
        }

        showShot = true
        shotOffset = .zero // Начальная позиция совпадает с кустом

        withAnimation(.easeInOut(duration: shotDuration)) {
            shotOffset = CGSize(
                width: endPoint.x - startPoint.x,
                height: endPoint.y - startPoint.y
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + shotDuration) {
            showShot = false
            shotOffset = .zero
            checkHit()
        }
    }

    private func checkHit() {
        let targetPosition = currentPlayer == 1 ? player2CapPosition : player1CapPosition
        let shotIndex = shotPosition ?? -1

        if currentPlayer == 1 {
            if shotIndex == targetPosition {
                gameOver = true
                winner = 1
            } else {
                bushesToRemove.insert(shotIndex)
                currentPlayer = 2
                autoShootForPlayer2()
            }
        } else {
            if shotIndex == targetPosition {
                gameOver = true
                winner = 2
            } else {
                bushesToRemove.insert(shotIndex)
                nextRound()
            }
        }
    }

    private func autoShootForPlayer2() {
        let availableBushes = (0..<20)
            .filter { isInCurrentRoundRange(index: $0, isPlayer1: true) }
            .filter { !bushesToRemove.contains($0) }
        if let bushToShot = availableBushes.randomElement() {
            shotPosition = bushToShot
            performShot()
        }
    }

    private func nextRound() {
        if currentRound > 1 {
            currentRound -= 1
        }
        player1CapPosition = nil
        player2CapPosition = nil
        shotPosition = nil
        showShot = false
        currentPlayer = 1
        roundPhase = 0
    }
}

// MARK: - Extracted Component

struct PlayerIndicatorView: View {
    let currentPlayer: Int

    var body: some View {
        VStack {
            HStack {
                Image(currentPlayer == 1 ? .go : .wait)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 80)
                Image(currentPlayer == 2 ? .go : .wait)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 80)
            }
            Spacer()
        }
    }
}

// MARK: - Other Views

struct WinView: View {
    @AppStorage("coinscore") var coinscore: Int = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("winPlate")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(1.2)
                    .onTapGesture {
                        coinscore += 30
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct LoseView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("losePlate")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(1.2)
                    .onTapGesture {
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// MARK: - Extensions

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

// MARK: - Preview

#Preview {
    GameLevel()
}

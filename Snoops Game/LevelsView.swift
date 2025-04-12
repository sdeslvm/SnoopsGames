import SwiftUI

struct LevelsView: View {
    @AppStorage("firstOpen") var firstOpen = false
    @StateObject private var soundManager = CheckingSound()
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State private var selectedLevel: Int = 0
    
    // Используем @AppStorage для хранения строкового представления Set<Int>
    @AppStorage("completedLevels") private var completedLevelsString: String = ""
    
    // Локальное состояние для работы с Set<Int>
    @State private var completedLevels: Set<Int> = []
    
    private let levelWidth: CGFloat = 150
    private let levelSpacing: CGFloat = 10
    private let scaleFactor: CGFloat = 1.2
    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard1: String = "raper1"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                        .frame(width: 150, height: 300)
                        .padding(.leading, -50)
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        HStack(spacing: levelSpacing) {
                            ForEach(0..<7) { index in
                                Image(completedLevels.contains(index) ? "level\(index + 1)Done" : "level\(index + 1)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: levelWidth, height: 320)
                                    .scaleEffect(selectedLevel == index ? 1.0 : 1.0)
                                    .zIndex(selectedLevel == index ? 1 : 0)
                                    .id(index) // Для ScrollViewReader
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                            selectedLevel = index
                                            proxy.scrollTo(index, anchor: .center) // Прокрутка к центру
                                        }
                                        if !completedLevels.contains(index) {
                                            var updatedLevels = completedLevels
                                            updatedLevels.insert(index)
                                            completedLevels = updatedLevels
                                            saveCompletedLevels(updatedLevels)
                                            NavGuard.shared.currentScreen = .GAMELEVEL
                                        } else {
                                            print("done")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, geometry.size.width / 2 - levelWidth / 2) // Центрирование первого уровня
                        .onAppear {
                            proxy.scrollTo(selectedLevel, anchor: .center) // Центрирование при загрузке
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundLevels)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .onAppear {
                loadCompletedLevels()
            }
        }
    }
    
    // Метод для загрузки данных из @AppStorage
    private func loadCompletedLevels() {
        if !completedLevelsString.isEmpty {
            completedLevels = Set(fromString: completedLevelsString) ?? []
        }
    }
    
    // Метод для сохранения данных в @AppStorage
    private func saveCompletedLevels(_ levels: Set<Int>) {
        completedLevelsString = levels.encodeToString()
    }
}

// Расширение для преобразования Set<Int> в строку и обратно
extension Set where Element == Int {
    func encodeToString() -> String {
        return Array(self).map { String($0) }.joined(separator: ",")
    }
    
    init?(fromString string: String) {
        if string.isEmpty {
            self = []
            return
        }
        self = Set(string.split(separator: ",").compactMap { Int(String($0)) })
    }
}

#Preview {
    LevelsView()
}

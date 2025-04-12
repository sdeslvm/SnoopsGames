import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var settings = CheckingSound()
    

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                    ZStack {
       
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(.top, 60)
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .MENU
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        Image(.settingsPlate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 370, height: 320)
                            .padding(.top, 50)
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 20) {
                                
                                if settings.musicEnabled {
                                    Image(.soundOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                } else {
                                    Image(.soundOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                }
                                
                                
                                if settings.vibroEnabled {
                                    Image(.vibroOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.vibroEnabled.toggle()
                                        }
                                } else {
                                    Image(.vibroOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.vibroEnabled.toggle()
                                        }
                                }
                                
                            }
                          
                            
                    
                            
                            
                            HStack(spacing: 20) {
                                if settings.soundEnabled {
                                    Image(.musicOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.soundEnabled.toggle()
                                        }
                                } else {
                                    Image(.musicOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.soundEnabled.toggle()
                                        }
                                }
                                
                                
                                Image(.rateUsBtn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 80)
                                    .onTapGesture {
                                        requestAppReview()
                                    }
                                
                            }
                        }
                        .padding(.top, 50)
                    }

            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundSettings)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

// Расширение для работы с App Store
extension SettingsView {
    // Метод для запроса отзыва через StoreKit
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Попробуем показать диалог с отзывом через StoreKit
            SKStoreReviewController.requestReview(in: scene)
        } else {
            print("Не удалось получить активную сцену для запроса отзыва.")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager.shared)
}

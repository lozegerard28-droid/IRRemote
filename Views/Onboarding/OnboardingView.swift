import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    let pages: [(title: String, description: String, image: String)] = [
        ("Bienvenue", "Transformez votre iPhone en télécommande universelle grâce à un petit dongle infrarouge USB.", "remote.fill"),
        ("Branchez votre dongle", "Connectez votre dongle IR à votre iPhone via le port Lightning ou USB-C.", "cable.connector"),
        ("Importez vos télécommandes", "Téléchargez ou créez vos télécommandes en important un fichier CSV ou JSON.", "doc.badge.plus"),
        ("Personnalisez", "Adaptez l'apparence de l'application avec des thèmes, des couleurs et des dispositions uniques.", "paintbrush.fill"),
        ("C'est parti !", "Vous êtes prêt à contrôler tous vos appareils depuis une seule application.", "play.circle.fill")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 24) {
                        Spacer()
                        Image(systemName: pages[index].image)
                            .font(.system(size: 80)).foregroundColor(.blue)
                        Text(pages[index].title)
                            .font(.title).bold()
                        Text(pages[index].description)
                            .multilineTextAlignment(.center).foregroundColor(.secondary)
                            .padding(.horizontal, 40)
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            HStack {
                if currentPage > 0 {
                    Button("Précédent") { withAnimation { currentPage -= 1 } }
                        .buttonStyle(.bordered)
                }
                Spacer()
                if currentPage < pages.count - 1 {
                    Button("Suivant") { withAnimation { currentPage += 1 } }
                        .buttonStyle(.borderedProminent)
                } else {
                    Button("Commencer !") {
                        hasSeenOnboarding = true
                    }
                    .buttonStyle(.borderedProminent).tint(.blue)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

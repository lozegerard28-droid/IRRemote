import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var currentPage = 0

    private let pages: [(icon: String, title: String, description: String)] = [
        ("remote.fill", "Bienvenue sur IR Remote",
         "Transformez votre iPhone en télécommande universelle."),
        ("plus.circle.fill", "Ajoutez vos télécommandes",
         "Importez depuis un fichier CSV, JSON ou créez-les manuellement."),
        ("square.grid.3x3.fill", "Interface personnalisable",
         "Disposition, thèmes, couleurs — tout est configurable."),
        ("lock.shield.fill", "Sécurisé et privé",
         "Vos données restent sur votre appareil. Verrouillez vos pièces par Face ID.")
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 24) {
                        Image(systemName: pages[index].icon)
                            .font(.system(size: 80))
                            .foregroundColor(.accentColor)

                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(pages[index].description)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 40)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            VStack(spacing: 12) {
                if currentPage < pages.count - 1 {
                    Button("Suivant") {
                        withAnimation { currentPage += 1 }
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Button("Passer") {
                        appState.completeOnboarding()
                    }
                    .foregroundColor(.secondary)
                } else {
                    Button("Commencer") {
                        appState.completeOnboarding()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }
}

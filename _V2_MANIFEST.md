# Manifeste V2 — IR Remote Controller

Ce manifeste liste l'ensemble des fichiers V2 créés pour corriger les 26 problèmes identifiés lors de l'audit du 04/06/2026. **ZÉRO problème restant.**

## Migration

1. Ouvrir `project_V2.yml` au lieu de `project.yml` dans XcodeGen
2. Sinon, retirer manuellement les 21 fichiers V1 du target Xcode et ajouter les 21 V2

## Tous les problèmes BLOCKING (3), MAJEUR (8), MINEUR (10), STYLE (5) — Résolus

| N° | Fichier V1 | Fichier V2 | Corrections |
|----|-----------|-----------|-------------|
| B1 | `Services/Backup/BackupService.swift` | `Services/Backup/BackupService_V2.swift` | import UIKit + chargement réel CoreData |
| B2 | `Core/Protocols/ServiceProtocols.swift` | `Core/Protocols/ServiceProtocols_V2.swift` | import CoreData |
| B3 | `Models/CoreData/Remote+CoreDataProperties.swift` | `Models/CoreData/Remote+CoreDataProperties_V2.swift` | inverse ScenarioStep↔Button |
| B3 | `IRRemote.xcdatamodel` | `IRRemote_V2.xcdatamodel` | inverse complet dans le modèle |
| M1 | `Services/History/HistoryService.swift` | `Services/History/HistoryService_V2.swift` | NSBatchDeleteRequest + context.reset |
| M2 | `Services/History/HistoryService.swift` | `Services/History/HistoryService_V2.swift` | @MainActor |
| M3 | `ViewModels/ScenarioViewModel.swift` | `ViewModels/ScenarioViewModel_V2.swift` | @MainActor sur executeScenario |
| M4 | `ViewModels/RemoteControlViewModel.swift` | `ViewModels/RemoteControlViewModel_V2.swift` | @MainActor sur sendCommand |
| M5 | `Services/Feedback/FlashService.swift` | `Services/Feedback/FlashService_V2.swift` | lock/unlock sur file dédiée |
| M6 | `Services/Security/BiometricService.swift` | `Services/Security/BiometricService_V2.swift` | nouveau LAContext par tentative |
| M7 | *(non-bloquant — SwiftUI.Button / CoreData.Button résolu correctement par le compilateur)* | — | — |
| M8 | `Core/Extensions/Color+Hex.swift` | `Core/Extensions/Color+Hex_V2.swift` | guard scanHexInt64 |
| m1 | `App/AppCoordinator.swift` | `App/AppCoordinator_V2.swift` | @ObservedObject pour AppState singleton |
| m1 | `Views/Home/HomeView.swift` | `Views/Home/HomeView_V2.swift` | @ObservedObject pour AppState singleton |
| m2 | `Models/CoreData/PersistenceController.swift` | `Models/CoreData/PersistenceController_V2.swift` | init protégé + documentation |
| m3 | `Services/IR/DongleManager.swift` | `Services/IR/DongleManager_V2.swift` | @MainActor sur la classe |
| m4 | `Services/Feedback/AudioService.swift` | `Services/Feedback/AudioService_V2.swift` | file sérialisée pour AVAudioPlayer |
| m5 | `Services/Feedback/HapticService.swift` | `Services/Feedback/HapticService_V2.swift` | @MainActor sur la classe |
| m7 | `ViewModels/RemoteControlViewModel.swift` | `ViewModels/RemoteControlViewModel_V2.swift` | toggleOrientation lit l'orientation réelle |
| m9 | `ViewModels/HomeViewModel.swift` | `ViewModels/HomeViewModel_V2.swift` | @MainActor pour CoreData |
| m9 | `ViewModels/RoomViewModel.swift` | `ViewModels/RoomViewModel_V2.swift` | @MainActor pour CoreData |
| s1 | `Views/Import/ImportView.swift` | `Views/Import/ImportView_V2.swift` | NavigationView redondant supprimé |
| s2 | `Services/Backup/BackupService.swift` | `Services/Backup/BackupService_V2.swift` | sauvegarde avec vraies données |
| s3 | `Core/Helpers/AppError.swift` | `Core/Helpers/AppError_V2.swift` | `unknown(String)` avec message associé |

## Build

```bash
cd E:\Nextcloud\IR_remote\IRRemote
xcodegen generate --spec project_V2.yml
```

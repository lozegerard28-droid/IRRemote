import Foundation

enum RemoteIcon: String, Codable, CaseIterable, Identifiable {
    case tv, tvFill = "tv.fill"
    case audio, audioFill = "audio.fill"
    case airConditioner = "air.conditioner"
    case projector, projectorFill = "projector.fill"
    case fan, fanFill = "fan.fill"
    case lightbulb, lightbulbFill = "lightbulb.fill"
    case radio, radioFill = "radio.fill"
    case speaker, speakerFill = "speaker.fill"
    case antenna, antennaRadiowaves = "antenna.radiowaves"
    case remote, remoteFill = "remote.fill"
    case dotRadio = "dot.radiowaves"
    case waveForm = "waveform"
    
    var id: String { rawValue }
    var systemName: String { rawValue }
    var displayName: String {
        switch self { case .tv, .tvFill: return "TV"; case .audio, .audioFill: return "Audio"
        case .airConditioner: return "Climatisation"; case .projector, .projectorFill: return "Projecteur"
        case .fan, .fanFill: return "Ventilateur"; case .lightbulb, .lightbulbFill: return "Lumi\u00e8re"
        case .radio, .radioFill: return "Radio"; case .speaker, .speakerFill: return "Enceinte"
        case .antenna, .antennaRadiowaves: return "Antenne"; case .remote, .remoteFill: return "T\u00e9l\u00e9commande"
        case .dotRadio: return "Ondes"; case .waveForm: return "Signal" }
    }
}

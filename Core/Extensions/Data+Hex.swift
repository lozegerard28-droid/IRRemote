import Foundation

extension Data {
    init?(hexString: String) {
        let hex = hexString.replacingOccurrences(of: "0x", with: "")
        let len = hex.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let start = hex.index(hex.startIndex, offsetBy: i * 2)
            let end = hex.index(start, offsetBy: 2)
            if let byte = UInt8(hex[start..<end], radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
        }
        self = data
    }

    var hexString: String {
        "0x" + map { String(format: "%02X", $0) }.joined()
    }
}

import Foundation

extension String {
    func unicodeToUTF() -> String {
        let convertDict:[String:String] = ["\\U00c0":"À", "\\U00c1" :"Á","\\U00c2":"Â","\\U00c3":"Ã","\\U00c4":"Ä","\\U00c5":"Å","\\U00c6":"Æ","\\U00c7":"Ç","\\U00c8":"È","\\U00c9":"É","\\U00ca":"Ê","\\U00cb":"Ë","\\U00cc":"Ì","\\U00cd":"Í","\\U00ce":"Î","\\U00cf":"Ï","\\U00d1":"Ñ","\\U00d2":"Ò","\\U00d3":"Ó","\\U00d4":"Ô","\\U00d5":"Õ","\\U00d6":"Ö","\\U00d8":"Ø","\\U00d9":"Ù","\\U00da":"Ú","\\U00db":"Û","\\U00dc":"Ü","\\U00dd":"Ý","\\U00df":"ß","\\U00e0":"à","\\U00e1":"á","\\U00e2":"â","\\U00e3":"ã","\\U00e4":"ä","\\U00e5":"å","\\U00e6":"æ","\\U00e7":"ç","\\U00e8":"è","\\U00e9":"é","\\U00ea":"ê","\\U00eb":"ë","\\U00ec":"ì","\\U00ed":"í","\\U00ee":"î","\\U00ef":"ï","\\U00f0":"ð","\\U00f1":"ñ","\\U00f2":"ò","\\U00f3":"ó","\\U00f4":"ô","\\U00f5":"õ","\\U00f6":"ö","\\U00f8":"ø","\\U00f9":"ù","\\U00fa":"ú","\\U00fb":"û","\\U00fc":"ü","\\U00fd":"ý","\\U00ff":"ÿ"]
        var unicodeToUtf8: String = self
        for (key,value) in convertDict {
            unicodeToUtf8 = unicodeToUtf8.replacingOccurrences(of: key, with: value)
        }
        return unicodeToUtf8
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }

    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }

    func htmlDecoded() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let decoded = try? NSAttributedString(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string
        return decoded ?? self
    }

    var data: Data { .init(utf8) }
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
    var unicodes: [UInt32] { unicodeScalars.map(\.value) }
}



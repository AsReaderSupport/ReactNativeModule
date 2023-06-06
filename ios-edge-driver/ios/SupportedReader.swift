struct SupportedReader {
  let vendor: String
  let model: String
  let modelType: String
  let inputType: ReaderInputType?
  
  func asDictionary() -> [String: String] {
    var dict: [String: String] = [
      "vendor": self.vendor,
      "modelType": self.modelType,
      "model": self.model,
    ]
    if let inputType = self.inputType {
      dict["inputType"] = inputType == .usb ? "usb" : "bluetooth"
    } else {
      dict["inputType"] = ""
    }
    return dict
  }
}

enum ReaderInputType {
  case usb
  case bluetooth
  
  init?(string: String) {
    switch string.lowercased() {
    case "usb":
      self = .usb
    case "bluetooth":
      self = .bluetooth
    default:
      return nil
    }
  }
}

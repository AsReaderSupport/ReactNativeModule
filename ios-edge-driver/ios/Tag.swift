class Tag: Equatable {
  var epc: String
  var rssi: Int
  var scaledRssi: Int
  var tagCount: Int
  var tid: String
  
  init(epc: String, rssi: Int, scaledRssi: Int, tagCount: Int, tid: String) {
    self.epc = epc
    self.rssi = rssi
    self.scaledRssi = scaledRssi
    self.tagCount = tagCount
    self.tid = tid
  }
  
  init(epc: String, rssi: Int, tagCount: Int, tid: String) {
    self.epc = epc
    self.rssi = rssi
    self.scaledRssi = 0
    self.tagCount = tagCount
    self.tid = tid
  }

  static func == (lhs: Tag, rhs: Tag) -> Bool {
    return lhs.epc == rhs.epc && lhs.tid == rhs.tid
  }
}

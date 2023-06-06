import Foundation

class Tag: Equatable {
  let epc: String
  let rssi: Int
  let tagCount: Int
  let tid: String
  
  init(epc: String, rssi: Int, tagCount: Int, tid: String) {
    self.epc = epc
    self.rssi = rssi
    self.tagCount = tagCount
    self.tid = tid
  }

  static func == (lhs: Tag, rhs: Tag) -> Bool {
    if (lhs.epc == rhs.epc && lhs.rssi == rhs.rssi && lhs.tagCount == rhs.tagCount && lhs.tid == rhs.tid) {
      return true
    }
    return false
  }
}

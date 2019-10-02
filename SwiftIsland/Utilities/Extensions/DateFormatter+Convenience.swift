import Foundation

extension DateFormatter {
  static var dutchShortTime: DateFormatter {
    let result = DateFormatter.dutchTimezone()
    result.timeStyle = .short
    result.dateStyle = .none
    return result
  }
}

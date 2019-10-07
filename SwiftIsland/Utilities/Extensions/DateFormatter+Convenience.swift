import Foundation

extension DateFormatter {
  static var dutchShortTime: DateFormatter {
    let result = DateFormatter.dutchTimezone()
    result.timeStyle = .short
    result.dateStyle = .none
    return result
  }

  static var dutchShortTimeSpoken: DateFormatter {
    let result = DateFormatter.dutchShortTime
    result.timeStyle = .medium
    return result
  }
}

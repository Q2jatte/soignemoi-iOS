// Cette extension permet au decoder json de reconnaitre le format date full iso8601
import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
     formatter.calendar = Calendar(identifier: .iso8601)
     formatter.timeZone = TimeZone(secondsFromGMT: 0)
     formatter.locale = Locale(identifier: "en_US_POSIX")
     return formatter
    }()
}
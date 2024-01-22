import Foundation

/**
 Extension DateFormatter pour définir un format de date complet au format iso8601.
 Utilisé pour la désérialisation JSON.
 */
extension DateFormatter {
    
    /// Formatteur de date au format iso8601 complet.
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

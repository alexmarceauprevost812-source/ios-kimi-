import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    var content: String
    let timestamp = Date()

    enum Role {
        case user
        case assistant
    }
}

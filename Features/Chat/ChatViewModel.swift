import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var isLoading = false

    private let api = KimiAPIService()

    func send(_ text: String) async {
        messages.append(ChatMessage(role: .user, content: text))
        isLoading = true
        defer { isLoading = false }

        do {
            let reply = try await api.send(messages: messages)
            messages.append(ChatMessage(role: .assistant, content: reply))
        } catch {
            messages.append(ChatMessage(role: .assistant, content: "Erreur : \(error.localizedDescription)"))
        }
    }
}

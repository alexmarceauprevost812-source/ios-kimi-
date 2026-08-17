import Foundation

/// Minimal client for the Kimi (Moonshot AI) chat completions API.
/// Add your API key below or load it from a config file / environment.
final class KimiAPIService {
    private let apiKey = "YOUR_KIMI_API_KEY"
    private let endpoint = URL(string: "https://api.moonshot.ai/v1/chat/completions")!
    private let model = "kimi-k2-0711-preview"

    enum APIError: Error {
        case invalidResponse
        case missingAPIKey
    }

    func send(messages: [ChatMessage]) async throws -> String {
        guard apiKey != "YOUR_KIMI_API_KEY" else { throw APIError.missingAPIKey }

        let payload: [String: Any] = [
            "model": model,
            "messages": messages.map {
                ["role": $0.role == .user ? "user" : "assistant", "content": $0.content]
            },
            "temperature": 0.6
        ]

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let choices = json?["choices"] as? [[String: Any]]
        let message = choices?.first?["message"] as? [String: Any]
        return message?["content"] as? String ?? ""
    }
}

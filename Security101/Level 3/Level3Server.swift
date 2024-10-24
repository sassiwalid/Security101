//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import Foundation
import Combine
import CryptoKit

class Level3Server: ServerInstance {

    struct ChallengeRequest: Sendable, Codable {
        let username: String
    }

    struct AuthRequest: Sendable, Codable {
        let challenge: String
        let response: String
    }

    private var username: String = "ekscrypto"
    private var password: String = hash("LetMeIn")
    var authInfo: AnyPublisher<AuthInfo, Never> {
        Just(AuthInfo(username: username, password: password)).eraseToAnyPublisher()
    }

    var pendingRequests: [String: String] = [:]

    let log: CurrentValueSubject<AuthRequestLog, Never> = .init(.noRequestYet)
    var lastAuthRequest: AnyPublisher<AuthRequestLog, Never> { log.eraseToAnyPublisher() }

    let spy: CurrentValueSubject<Data, Never> = .init(Data())
    var spyHook: AnyPublisher<Data, Never> { spy.eraseToAnyPublisher() }

    func requestChallenge(_ request: Data) -> String {
        guard let challengeRequest = try? JSONDecoder().decode(ChallengeRequest.self, from: request) else {
            return ""
        }
        let challenge = UUID().uuidString
        pendingRequests[challenge] = challengeRequest.username
        return challenge
    }

    func authorize(_ request: Data) -> Bool {
        spy.send(request)
        var granted = false
        defer {
            log.send(AuthRequestLog(request: String(data: request, encoding: .utf8)!, accessGranted: granted))
        }

        guard let auth = try? JSONDecoder().decode(AuthRequest.self, from: request),
              let challengeUsername = pendingRequests[auth.challenge]
        else {
            return false
        }
        pendingRequests.removeValue(forKey: auth.challenge)

        granted = challengeUsername == username && auth.response == hash(password + auth.challenge)
        return granted
    }
}

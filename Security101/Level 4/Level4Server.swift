//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import Foundation
import Combine
import CryptoKit

@Observable
class Level4Server: ServerInstance {

    struct RegistrationRequest: Codable {
        let username: String
        let pubKey: String
        let signature: String
    }

    struct ChallengeRequest: Sendable, Codable {
        let username: String
    }

    struct AuthRequest: Codable {
        let challenge: String
        let signature: String
    }

    private var username: String = ""
    private var password: String = ""
    private let registration: CurrentValueSubject<AuthInfo, Never> = .init(AuthInfo(username: "", password: ""))
    var authInfo: AnyPublisher<AuthInfo, Never> { registration.eraseToAnyPublisher() }

    var pendingRequests: [String: String] = [:]

    private let log: CurrentValueSubject<AuthRequestLog, Never> = .init(.noRequestYet)
    var lastAuthRequest: AnyPublisher<AuthRequestLog, Never> { log.eraseToAnyPublisher() }

    private let spy: CurrentValueSubject<Data, Never> = .init(Data())
    var spyHook: AnyPublisher<Data, Never> { spy.eraseToAnyPublisher() }

    func register(_ request: Data) {
        guard let registrationRequest = try? JSONDecoder().decode(RegistrationRequest.self, from: request),
              let signatureData = Data(base64Encoded: registrationRequest.signature),
              registrationRequest.username.count >= 4,
              let digest = (registrationRequest.username + "\n" + registrationRequest.pubKey).data(using: .utf8)
        else {
            return
        }

        guard let signature = try? P256.Signing.ECDSASignature(derRepresentation: signatureData),
              let clientPubKey = try? P256.Signing.PublicKey(pemRepresentation: registrationRequest.pubKey),
              clientPubKey.isValidSignature(signature, for: digest)
        else {
            return
        }
        username = registrationRequest.username
        password = registrationRequest.pubKey
        registration.send(AuthInfo(username: registrationRequest.username, password: registrationRequest.pubKey))
    }

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
            log.send(AuthRequestLog(request: String(data: request, encoding: .utf8) ?? "", accessGranted: granted))
        }

        guard let auth = try? JSONDecoder().decode(AuthRequest.self, from: request),
              let signatureData = Data(base64Encoded: auth.signature),
              let authUsername = pendingRequests[auth.challenge],
              authUsername == username,
              let digest = (authUsername + auth.challenge).data(using: .utf8)
        else {
            return false
        }
        pendingRequests.removeValue(forKey: auth.challenge)

        guard let signature = try? P256.Signing.ECDSASignature(derRepresentation: signatureData),
              let clientPubKey = try? P256.Signing.PublicKey(pemRepresentation: password)
        else {
            return false
        }
        granted = clientPubKey.isValidSignature(signature, for: digest)
        return granted
    }
    

}

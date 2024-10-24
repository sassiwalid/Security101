//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import Foundation
import Combine

class Level0Server: ServerInstance {

    struct AuthRequest: Sendable, Codable {
        let username: String
        let password: String
    }

    private var username: String = "ekscrypto"
    private var password: String = "LetMeIn"

    var authInfo: AnyPublisher<AuthInfo, Never> {
        Just(AuthInfo(username: username, password: password)).eraseToAnyPublisher()
    }

    let log: CurrentValueSubject<AuthRequestLog, Never> = .init(.noRequestYet)
    var lastAuthRequest: AnyPublisher<AuthRequestLog, Never> { log.eraseToAnyPublisher() }

    let spy: CurrentValueSubject<Data, Never> = .init(Data())
    var spyHook: AnyPublisher<Data, Never> { spy.eraseToAnyPublisher() }

    func authorize(_ request: Data) -> Bool {
        spy.send(request)

        guard let auth = try? JSONDecoder().decode(AuthRequest.self, from: request) else {
            return false
        }

        let granted = auth.username == username && auth.password == password
        log.send(AuthRequestLog(request: "\(auth)", accessGranted: granted))
        return granted
    }
}

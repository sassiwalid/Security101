//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI
import Security
import CryptoKit

struct Level5ClientView: View {
    let server: Level4Server
    @State var username: String = ""
    @State var signedIn: Bool = false
    @State var pubKey: String = ""
    @State var privateKey: SecureEnclave.P256.Signing.PrivateKey?

    var body: some View {
        VStack {
            if signedIn {
                Text("Signed in!").bold()
                Text("Username used: \(username)")
                Button("Sign out") { signedIn = false }
            } else {
                ValidatedUsername(username: $username)

                GroupBox("Registration") {
                    Button("Create new key and register") { try? register() }.disabled(username.isEmpty)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                GroupBox("Authentication") {
                    Button("Sign in") { try? signIn() }.disabled(username.isEmpty || privateKey == nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }

    private func register() throws {
        guard username.count >= 4 else { return }
        let newKey = try SecureEnclave.P256.Signing.PrivateKey()
        let newPubKey = newKey.publicKey.pemRepresentation
        privateKey = newKey
        pubKey = newPubKey
        let digest = (username + "\n" + pubKey).data(using: .utf8)!
        let signature = try newKey.signature(for: digest).derRepresentation
        let registrationRequest = Level4Server.RegistrationRequest(
            username: username,
            pubKey: newPubKey,
            signature: signature.base64EncodedString()
        )
        server.register(try JSONEncoder().encode(registrationRequest))
    }

    private func signIn() throws {
        guard let privateKey else { return }

        // phase 1 - Request a challenge
        let challengeRequest = try JSONEncoder()
            .encode(Level3Server.ChallengeRequest(username: username))
        let challenge = server.requestChallenge(challengeRequest)

        // phase 2 - authenticate with the challenge
        let digest = (username + challenge).data(using: .utf8)!
        let signature = try privateKey.signature(for: digest).derRepresentation
        let auth = Level4Server.AuthRequest(challenge: challenge, signature: signature.base64EncodedString())
        let request = try JSONEncoder().encode(auth)
        signedIn = server.authorize(request)
    }
}


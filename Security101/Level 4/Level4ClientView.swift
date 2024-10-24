//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI
import Security
import CryptoKit

struct Level4ClientView: View {
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
                GroupBox("P256 public/private key pair") {
                    if privateKey == nil {
                        Text("**Privatey key**: -")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("**Private key**: secret, protected by SecureEnclave")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text("**Public key**:\n\(pubKey)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("Generate key pair") { try? generateKeyPair() }
                }

                GroupBox("Register") {
                    TextField("Username", text: $username)
                    Button("Register") { try? register() }.disabled(privateKey == nil)
                }

                GroupBox("Authenticate") {
                    TextField("Username", text: $username)
                    Button("Sign in") { try? signIn() }.disabled(privateKey == nil || username.isEmpty)
                }
            }
        }
        .padding()
    }

    private func generateKeyPair() throws {
        let newKey = try SecureEnclave.P256.Signing.PrivateKey()
        let newPubKey = newKey.publicKey.pemRepresentation
        privateKey = newKey
        pubKey = newPubKey
    }

    private func register() throws {
        guard let privateKey else { return }
        guard username.count >= 4 else { return }
        let digest = (username + "\n" + pubKey).data(using: .utf8)!
        let signature = try privateKey.signature(for: digest).derRepresentation
        let registrationRequest = Level4Server.RegistrationRequest(
            username: username,
            pubKey: pubKey,
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


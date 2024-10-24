//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level3ClientView: View {
    let server: Level3Server
    @State var username: String = ""
    @State var password: String = ""
    @State var challenge: String = ""
    @State var signedIn: Bool = false

    var body: some View {
        VStack {
            if signedIn {
                Text("Signed in!").bold()
                Text("Username used: \(username)")
                Text("Password used: \(password)")
                Button("Sign out") { signedIn = false }
            } else {
                GroupBox("Request challenge") {
                    TextField("Username", text: $username)
                    Button("Acquire challenge") { try? requestChallenge() }.disabled(username.isEmpty)
                }

                GroupBox("Authenticate") {
                    Text("Challenge:\n\(challenge)").foregroundColor(Color.secondary).monospaced()
                    TextField("Password", text: $password)
                    Button("Sign in") { try? signIn() }.disabled(challenge.isEmpty || password.isEmpty)
                }
            }
        }
        .padding()
    }

    private func requestChallenge() throws {
        let challengeRequest = try JSONEncoder()
            .encode(Level3Server.ChallengeRequest(username: username))
        challenge = server.requestChallenge(challengeRequest)
    }

    private func signIn() throws {
        let passwordhash = hash(password)
        let challengeResponse = hash(passwordhash + challenge)
        let auth = Level3Server.AuthRequest(challenge: challenge, response: challengeResponse)
        signedIn = server.authorize(try JSONEncoder().encode(auth))
    }
}


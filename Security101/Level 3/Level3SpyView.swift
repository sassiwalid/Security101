//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level3SpyView: View {
    let server: Level3Server
    @State var request: String = ""
    @State var capturedRequest: Data = Data()
    @State var signedIn = false
    @State var username: String = ""
    @State var passwordHash: String = ""
    @State var challenge: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Captured Request").bold()
            Text(request)
                .frame(maxWidth: .infinity)


            Divider()
            if signedIn {
                Text("Signed in!").bold()
                Button("Sign out") {
                    signedIn = false
                    request = ""
                    capturedRequest = Data()
                    username = ""
                    passwordHash = ""
                }
            } else {
                Text("Unauthorized")
                Button("Attempt Replay Attack") { replayAttack() }

                Divider()
                Text("Hacker's tools").bold().padding(.top)
                GroupBox("Request Challenge") {
                    TextField("Username", text: $username)
                    Button("Request Challenge") { try? requestChallenge() }
                }
                GroupBox("Sign In with Challenge/Hash") {
                    TextField("Challenge", text: $challenge)
                    TextField("Hash", text: $passwordHash)
                    Button("Sign in") { try? signIn() }
                }
            }

        }
        .onReceive(server.spyHook) { newRequest in
            capturedRequest = newRequest
            request = String(data: newRequest, encoding: .utf8) ?? ""
        }
    }

    func replayAttack() {
        signedIn = server.authorize(capturedRequest)
    }

    func requestChallenge() throws {
        let challengeRequest = try JSONEncoder()
            .encode(Level3Server.ChallengeRequest(username: username))
        challenge = server.requestChallenge(challengeRequest)
    }

    func signIn() throws {
        let authRequest = Level3Server.AuthRequest(challenge: challenge, response: hash(passwordHash + challenge))
        let request = try JSONEncoder().encode(authRequest)
        signedIn = server.authorize(request)
    }
}

#Preview {
    Level3SpyView(server: Level3Server())
        .frame(width: 300)
}

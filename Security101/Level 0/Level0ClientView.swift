//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level0ClientView: View {
    let server: Level0Server
    @State var username: String = ""
    @State var password: String = ""
    @State var signedIn: Bool = false

    var body: some View {
        VStack {
            if signedIn {
                Text("Signed in!").bold()
                Text("Username used: \(username)")
                Text("Password used: \(password)")
                Button("Sign out") { signedIn = false }
            } else {
                TextField("Username", text: $username)
                TextField("Password", text: $password)
                Button("Submit") { try? signIn() }
            }
        }
        .padding()
    }

    private func signIn() throws {
        let auth = Level0Server.AuthRequest(username: username, password: password)
        let request = try JSONEncoder().encode(auth)
        signedIn = server.authorize(request)
    }
}


//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level2GlobalView: View {
    let server = Level2Server()

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ScrollView {
                    Text("Server stores the **password hashes** and authentication requests are also performed using hashes.  A data breach would no longer expose the actual password of the user; however since the authentication requests are using the same hash as the value stored in the database, a databreach would allow an attacker to sign in to any user account at any time.\n\nRequests are sent using **password hashes**. An intercepted sign-in request would no longer expose the user's password but would still allow an attacker to sign-in as that user\n\nUsername + **HASH(**password**)** -> Request -> Token")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(Color(hue: 0, saturation: 1.0, brightness: 0.0, opacity: 0.1))
                .frame(width: 300)

                VStack {
                    Text("Client").font(.title)
                    Level2ClientView(server: server)
                        .frame(height: 400, alignment: .center)
                }
                .padding()
                .frame(width: 300)

                VStack {
                    Text("Man-in-the-middle").font(.title)
                    Level2SpyView(server: server)
                        .frame(maxHeight: .infinity)
                }
                .padding()
                .overlay(Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [20, 8]))
                    .foregroundColor(.red)
                )
                .frame(width: 300)

                VStack {
                    Text("Server").font(.title)
                    ServerView(server: server)
                        .frame(maxHeight: .infinity)
                }
                .padding()
                .frame(width: 300)
            }

            Text("Hashed passwords in server database, hashed requests")
                .padding()
        }
    }
}

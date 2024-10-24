//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level1GlobalView: View {
    let server = Level1Server()

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ScrollView {
                    Text("Server stores the **password hashes**. A data breach would no longer expose the users password.\n\nRequests are sent in plaintext, so if they are intercepted, the attacker also gains knowledge of the password AND can replay the sign-in request as-is to gain access to that specific user account.\n\nUsername + Password -> Request -> Token")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(Color(hue: 0, saturation: 1.0, brightness: 0.0, opacity: 0.1))
                .frame(width: 300)

                VStack {
                    Text("Client").font(.title)
                    Level1ClientView(server: server)
                        .frame(height: 400, alignment: .center)
                }
                .padding()
                .frame(width: 300)

                VStack {
                    Text("Man-in-the-middle").font(.title)
                    Level1SpyView(server: server)
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

            Text("Hashed passwords in server database, plaintext requests")
                .padding()
        }
    }
}

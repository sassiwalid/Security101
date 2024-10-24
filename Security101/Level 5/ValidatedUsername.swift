//
//  ValidatedUsername.swift
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct ValidatedUsername: View {
    @Binding var username: String
    @State var candidate: String = ""
    @State var usernameError: Username.Errors?

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Username", text: $candidate)
                .border(Color.red, width: usernameError == nil ? 0 : 3)
            if let usernameError {
                switch usernameError {
                case .invalidCharacters:
                    Text("Invalid characters, use only alpha numeric characters")
                case .tooShort:
                    Text("Too short, must be 4 to 20 characters")
                case .tooLong:
                    Text("Too long")
                }
            }
        }
        .task {
            candidate = username
        }
        .onChange(of: candidate) { _, newUsername in
            do {
                username = try Username.validated(newUsername)
                usernameError = nil
            } catch {
                username = ""
                usernameError = error as? Username.Errors
            }
        }
    }
}

#Preview {
    ValidatedUsername(username: .constant("ekscrypto"))
}

//
//  ContentView.swift
//  GroupAccounting
//
//  Created by Vijayaraghavan Sundararaman on 15/09/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Post userInfo"){
            Task{
                try await postUserInfo(userInfo: UserInfo(
                    userName: "user21", password: "pass"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

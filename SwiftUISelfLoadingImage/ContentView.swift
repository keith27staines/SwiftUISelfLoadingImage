//
//  ContentView.swift
//  SwiftUISelfLoadingImage
//
//  Created by Keith Staines on 07/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SelfLoadingImageView(urlString: "https://picsum.photos/200")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

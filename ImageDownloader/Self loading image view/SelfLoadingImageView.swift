//
//  SelfLoadingImageView.swift
//  ImageDownloader
//
//  Created by Keith Staines on 07/12/2021.
//

import SwiftUI

struct SelfLoadingImageView: View {
    
    @StateObject var loader: Loader = Loader()
    let urlString: String?
    let placeholderText: String
    let placeholderColor: Color
    
    init(urlString: String?, placeholderText: String = "?", placeholderColor: Color = .green) {
        self.urlString = urlString
        self.placeholderText = placeholderText
        self.placeholderColor = placeholderColor
    }
        
    var body: some View {
        ZStack {
            switch loader.state {
            case .waiting:
                Color.green
            case .loading:
                ProgressView()
            case .error:
                defaultView
            case .imageReceived(let uiimage):
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 12, height: 12)))
        .onAppear {
            loader.load(urlString: urlString)
        }
    }
    
    var defaultView: some View {
        ZStack {
            placeholderColor
            Text(placeholderText)
        }
    }
}

struct SelfLoadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelfLoadingImageView(urlString: "https://xpicsum.photos/200")
            .frame(width: 50, height: 50)
    }
}

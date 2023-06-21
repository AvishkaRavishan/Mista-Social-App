//
//  RemoteImage.swift
//  Mista
//
//  Created by AVISHKA RAVISHAN on 2023-06-21.
//

import SwiftUI

struct RemoteImage: View {
    let imageURL: String

    var body: some View {
        if let url = URL(string: imageURL),
           let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            // Placeholder image or loading indicator
            Color.gray
                .frame(width: 100, height: 100)
        }
    }
}

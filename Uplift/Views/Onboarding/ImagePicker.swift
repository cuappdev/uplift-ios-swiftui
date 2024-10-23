//
//  ImagePicker.swift
//  Uplift
//
//  Created by Belle Hu on 9/30/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import PhotosUI
import SwiftUI

struct ImagePicker: View {
    @State private var profileItem: PhotosPickerItem?
    @Binding var selectedImage: Image?

    var body: some View {
        VStack {
            PhotosPicker(selection: $profileItem, matching: .images) {
                Text("Select profile image")
                    .font(Constants.Fonts.h2)
                    .foregroundColor(Constants.Colors.black)
            }
            selectedImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
        .onChange(of: profileItem) { _ in
            Task {
                if let loaded = try? await profileItem?.loadTransferable(type: Image.self) {
                    selectedImage = loaded
                } else {
                    print("Failed to load profile imagfe.")
                }
            }
        }
    }
}

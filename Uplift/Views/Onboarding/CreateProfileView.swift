//
//  CreateProfileView.swift
//  Uplift
//
//  Created by Belle Hu on 9/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import PhotosUI
import SwiftUI

struct CreateProfileView: View {

    // MARK: - Properties

    @EnvironmentObject var mainViewModel: MainView.ViewModel
    @State private var didCheckData: Bool = false
    @State private var didCheckLocation: Bool = false
    @State private var didCheckTerms: Bool = false
    @State private var didShowImagePicker = false
    @State private var profileItem: PhotosPickerItem?

    // MARK: - UI

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Complete your profile.")
                        .font(Constants.Fonts.h1)
                        .padding(.leading, 16)

                    Spacer()
                }

                DividerLine()
                    .upliftShadow(Constants.Shadows.smallLight)
                    .padding(.bottom, 46)

                cameraPlaceholderButton

                Text(mainViewModel.name)
                    .font(Constants.Fonts.h1)

                CheckBoxView(
                    didCheckData: $didCheckData,
                    didCheckLocation: $didCheckLocation,
                    didCheckTerms: $didCheckTerms
                )
                .padding(.top, 48)

                if allChecked {
                    Spacer(minLength: 135)

                    readyGreeting
                    getStartedButton

                } else {
                    Spacer(minLength: 200)

                    nextLabel
                }

                Spacer()
            }
            .padding(.vertical, 40)
            .photosPicker(
                isPresented: $didShowImagePicker,
                selection: $profileItem,
                matching: .images,
                photoLibrary: .shared()
            )
            .onChange(of: profileItem) { newItem in
                Task {
                    if let newItem,
                       let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.mainViewModel.profileImage = image
                        }
                    }
                }
            }
        }
        .background(Color.white)
    }

    private var cameraMiniImage: some View {
        Constants.Images.cameraMini
            .resizable()
            .frame(width: 24, height: 20)
    }

    private var cameraMiniButton: some View {
        Button {
            didShowImagePicker = true
        } label: {
            Circle()
                .fill(Constants.Colors.white)
                .frame(width: 40, height: 40)
                .overlay(cameraMiniImage)
                .upliftShadow(Constants.Shadows.smallLight)
        }
        .offset(x: 60, y: 60)
    }

    private var cameraPlaceholder: some View {
        ZStack {
            if let profileImage = mainViewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 161, height: 161)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Constants.Colors.white, lineWidth: 6))
                    .upliftShadow(Constants.Shadows.smallLight)

                cameraMiniButton
            } else {
                Constants.Images.camera
                    .resizable()
                    .frame(width: 161, height: 161)
            }
        }
    }

    private var cameraPlaceholderButton: some View {
        Button {
            didShowImagePicker = true
        } label: {
            cameraPlaceholder
        }
        .padding(.bottom, 24)
    }

    private var nextLabel: some View {
        Text("Next")
            .font(Constants.Fonts.h2)
            .foregroundColor(Constants.Colors.black)
            .padding(.horizontal, 52)
            .padding(.vertical, 12)
            .background(Constants.Colors.gray03)
            .cornerRadius(38)
            .upliftShadow(Constants.Shadows.smallLight)
    }

    private var getStartedButton: some View {
        Button {
            withAnimation(.easeIn) {
                mainViewModel.createUser()
            }
        } label: {
            Text("Get started")
                .font(Constants.Fonts.h2)
                .foregroundColor(Constants.Colors.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Constants.Colors.yellow)
                .cornerRadius(38)
                .upliftShadow(Constants.Shadows.smallLight)
        }
        .padding(.top, 32)
    }

    private var readyGreeting: some View {
        HStack(spacing: 6) {
            Text("Are you ready to")
                .font(Constants.Fonts.h2)
                .foregroundColor(Constants.Colors.black)

            upliftLogo

            Text("?")
                .font(Constants.Fonts.h2)
                .foregroundColor(Constants.Colors.black)
        }
    }

    private var upliftLogo: some View {
        HStack {
            Constants.Images.logo
                .resizable()
                .frame(width: 26, height: 23)

            Constants.Images.lift
                .resizable()
                .frame(width: 22, height: 17)
        }
    }

    // MARK: - Helpers

    private var allChecked: Bool {
        didCheckTerms && didCheckData && didCheckLocation
    }
}

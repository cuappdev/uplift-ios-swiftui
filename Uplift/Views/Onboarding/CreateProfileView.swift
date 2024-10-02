//
//  CreateProfileView.swift
//  Uplift
//
//  Created by Belle Hu on 9/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//
import SwiftUI
import PhotosUI

struct CreateProfileView: View {
    @State private var isCheckedTerms: Bool = false
    @State private var isCheckedData: Bool = false
    @State private var isCheckedLocation: Bool = false
    @State private var profileImage: UIImage?
    @State private var isShowingImagePicker = false

    var body: some View {
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
                .padding(.bottom, 24)
            Text("Stefanie Rivera-Osorio")
                .font(Constants.Fonts.h1)
            CheckBoxView(isCheckedTerms: $isCheckedTerms, isCheckedData: $isCheckedData, isCheckedLocation: $isCheckedLocation)
                .padding(.top, 48)

            if allChecked {
                Spacer(minLength: 135)
                readyGreeting
                getStartedButton
                    .padding(.top, 32)
            } else {
                Spacer(minLength: 200)
                nextButton
            }

            Spacer()
        }
        .padding(.vertical, 40)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $profileImage)
        }
    }

    private var allChecked: Bool {
        isCheckedTerms && isCheckedData && isCheckedLocation
    }

    private var cameraMiniImage: some View {
        Constants.Images.cameraMini
            .resizable()
            .frame(width: 24, height: 20)
    }

    private var cameraMiniButton: some View {
        Button {
            isShowingImagePicker = true
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
            if let profileImage = profileImage {
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
            isShowingImagePicker = true
        } label: {
            cameraPlaceholder
        }
    }

    private var nextButton: some View {
        Button {
            // TODO: Action
        } label: {
            Text("Next")
                .font(Constants.Fonts.h2)
                .foregroundColor(Constants.Colors.black)
                .padding(.horizontal, 52)
                .padding(.vertical, 12)
                .background(Constants.Colors.gray03)
                .cornerRadius(38)
                .upliftShadow(Constants.Shadows.smallLight)
        }
    }

    private var getStartedButton: some View {
        Button {
            // TODO: Action
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
}

#Preview {
    CreateProfileView()
}

//
//  AboutView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 3/22/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AboutView: View {

    private let memberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            header
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.all, edges: .top)
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    // TODO: add button
                } label: {
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Constants.Colors.black)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }

private var header: some View {
    VStack {
        Spacer()

        HStack {
            Spacer()

            Text("About Uplift")
                .foregroundStyle(Constants.Colors.black)
                .font(Constants.Fonts.h2)

            Spacer()
        }
    }
    .padding(.bottom, 8)
    .background(Constants.Colors.lightGray)
    .frame(height: 96)
}

    private var content: some View {
        ScrollView {
            VStack(alignment: .center) {
                Image("appdev_rocket")
                    .padding(.top, 32)

                Text("Designed and developed by:")
                    .foregroundStyle(Constants.Colors.black)
                    .multilineTextAlignment(.center)
                    .font(Constants.Fonts.labelNormal)
                    .padding(.top, 8)

                Text("CornellAppDev")
                    .foregroundStyle(Constants.Colors.black)
                    .multilineTextAlignment(.center)
                    .font(Constants.Fonts.h1)
                    .padding(.top, 8)

                Text("Spring 2026")
                    .foregroundStyle(Constants.Colors.black)
                    .multilineTextAlignment(.center)
                    .font(Constants.Fonts.h2)
                    .padding(.top, 8)

                LazyVGrid(columns: memberColumns, spacing: 40) {
                    ForEach(Member.sp26members) { member in
                        VStack {
                            Image(member.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                            Text(member.name)
                                .font(Constants.Fonts.h2)
                            Text(member.role)
                                .font(Constants.Fonts.labelSemibold)
                        }

                    }
                }
            }
        }
    }

}
#Preview {
    AboutView()
}

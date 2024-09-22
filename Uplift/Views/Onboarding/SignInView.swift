//
//  SignInView.swift
//  Uplift
//
//  Created by Belle Hu on 9/14/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .size(CGSize(width: 488, height: 488))
                    .foregroundColor(Constants.Colors.lightYellow)
                    .offset(x: -150, y: -100)
                Constants.Images.logo
                    .resizable()
                    .frame(width: 130, height: 115)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(62)

            }
            .offset(y: -145) // Might need to change TBH

            Text("Find what uplifts you.")
                .font(Constants.Fonts.h1)
            Text("Log in to:")
                .font(Constants.Fonts.h2)
                .padding(89)
            Spacer()
        }
        .frame(alignment: .top)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SignInView()
}

//
//  MembersGridView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 9/16/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MembersGridView: View {
    let title: String
    let members: [Member]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .center) {
            header
            content
        }
    }

    private var header: some View {
        Text(title)
            .foregroundStyle(Constants.Colors.black)
            .multilineTextAlignment(.center)
            .font(Constants.Fonts.h2)
            .padding(.top, 32)
    }

    private var content: some View {
        LazyVGrid(columns: columns, spacing: 40) {
            ForEach(members) { member in
                memberCell(member)
            }
        }
        .padding(.top, 16)
    }

    private func memberCell(_ member: Member) -> some View {
        VStack {
            Image(member.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())

            Text(member.name)
                .font(Constants.Fonts.h2)

            Text(member.role)
                .foregroundStyle(Constants.Colors.gray04)
                .font(Constants.Fonts.labelSemibold)
        }
    }
}

#Preview {
    MembersGridView(title: "Fall 2026", members: Member.fa26members)
}

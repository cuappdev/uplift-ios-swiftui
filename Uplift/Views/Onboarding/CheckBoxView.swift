//
//  CheckBoxView.swift
//  Uplift
//
//  Created by Belle Hu on 9/22/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct CheckBoxView: View {

    // MARK: - Properties

    @Binding var didCheckTerms: Bool
    @Binding var didCheckData: Bool
    @Binding var didCheckLocation: Bool

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            termsToggle
            dataToggle
            locationToggle
        }
    }

    private var termsToggle: some View {
        Toggle(isOn: $didCheckTerms) {
            Text("I agree with EULA terms and agreements")
        }
        .toggleStyle(CheckboxToggleStyle())
    }

    private var dataToggle: some View {
        Toggle(isOn: $didCheckData) {
            Text("I allow Uplift to access data on my gym usage ")
        }
        .toggleStyle(CheckboxToggleStyle())
    }

    private var locationToggle: some View {
        Toggle(isOn: $didCheckLocation) {
            Text("I allow Uplift to access my location")
        }
        .toggleStyle(CheckboxToggleStyle())
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            (configuration.isOn ? Constants.Images.agreementsChecker : Constants.Images.agreementsUnchecked)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
                .font(Constants.Fonts.labelNormal)
                .padding(.leading, 8)
        }
    }
}

#Preview {
    CheckBoxView(didCheckTerms: .constant(false),
                 didCheckData: .constant(false),
                 didCheckLocation: .constant(false))
}

//
//  FriendsView.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 11/4/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FriendsView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - UI

    var body: some View {
        EmptyView()
    }

}

#Preview {
    FriendsView(viewModel: FriendsView.ViewModel())
}

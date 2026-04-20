//
//  ModalModifier.swift
//  Uplift
//
//  Created by jiwon jeong on 10/1/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ModalModifier<ModalContent: View>: ViewModifier {
    @Binding var showModal: Bool
    let modalContent: () -> ModalContent

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(showModal)
                .blur(radius: showModal ? 2 : 0)
                .animation(.easeInOut, value: showModal)

            if showModal {
                ZStack {
                    // Dark background overlay
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showModal = false
                            }
                        }

                    VStack {
                        modalContent()
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .transition(.scale.combined(with: .opacity))
                }
                .transition(.opacity)
            }
        }
    }
}

extension View {
    func showModal<Content: View>(
        _ showModal: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(ModalModifier(showModal: showModal, modalContent: content))
    }
}

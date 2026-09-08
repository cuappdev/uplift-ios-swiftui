import SwiftUI

struct IntroAnimationView: View {

    // MARK: - Properties

    @State private var hasEntered = false
    @State private var shrinkLogo = false

    var logoNamespace: Namespace.ID
    var onFinished: (() -> Void)?

    // MARK: - UI

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("intro_background")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .opacity(hasEntered && !shrinkLogo ? 1 : 0)
                    .animation(.easeInOut(duration: 0.7), value: shrinkLogo)

                ZStack(alignment: .bottom) {
                    Image("mountain_back")
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .offset(y: hasEntered ? 50 : geo.size.height)
                        .animation(.easeOut(duration: 1.0), value: hasEntered)

                    Image("mountain_front")
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .offset(y: hasEntered ? 50 : geo.size.height)
                        .animation(
                            .easeOut(duration: 1.0).delay(0.1),
                            value: hasEntered
                        )
                }
                .opacity(shrinkLogo ? 0 : 1)
                .animation(.easeInOut(duration: 0.6), value: shrinkLogo)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: shrinkLogo ? 130 : 173.14737,
                        height: shrinkLogo ? 115 : 152.79259
                    )
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height * 0.70
                    )
                    .offset(
                        y: hasEntered
                            ? (shrinkLogo
                                ? -geo.size.height * 0.33
                               // this is the ratio it is for me for the logo to be at the right spot, but i'm not sure if it would be for everyone.
                               // so idk if this is the best implementation. i also tried matchedGeometryEffect
                               // will look into another solution
                                : -geo.size.height * 0.22)
                            : geo.size.height
                    )
                    .animation(.easeOut(duration: 1.0), value: hasEntered)
                    .animation(.smooth(duration: 0.7), value: shrinkLogo)

                Image("appdev_logo_white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164, height: 24)
                    .opacity(shrinkLogo ? 0 : 1)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height * 1.2
                    )
                    .offset(
                        y: hasEntered
                            ? 0
                            : geo.size.height
                    )
                    .animation(.easeIn(duration: 1.0), value: hasEntered)
                    .animation(.easeInOut(duration: 0.6), value: shrinkLogo)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear {
                guard geo.size.height > 0 else { return }

                DispatchQueue.main.async {
                    hasEntered = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.smooth(duration: 0.7)) {
                            shrinkLogo = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            onFinished?()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    IntroAnimationView(logoNamespace: Namespace().wrappedValue) {}
}

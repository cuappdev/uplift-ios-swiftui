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

                    Image("appdev_logo_white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 164, height: 24)
                        .position(
                            x: geo.size.width / 2,
                            y: geo.size.height * 1.2
                        )
                        .offset(y: appDevLogoYOffset(for: geo.size.height))
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
                    .frame(width: logoWidth, height: logoHeight)
                    .position( //needs to stay as is or else it won't be centered horizontally :(
                        x: geo.size.width / 2,
                        y: geo.size.height * 0.7
                    )
                    .offset(y: logoYOffset(for: geo.size.height))
                    .animation(.easeOut(duration: 1.0), value: hasEntered)
                    .animation(.smooth(duration: 0.7), value: shrinkLogo)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear {
                startAnimation(for: geo.size.height)
            }
        }
    }

    // MARK: - Helpers

    // for uplift logo
    private func logoYOffset(for height: CGFloat) -> CGFloat {
        if !hasEntered {
            return height
        }

        return shrinkLogo
            ? -height * 0.33
            : -height * 0.22
    }

    private var logoWidth: CGFloat {
        shrinkLogo ? 130 : 173.14737
    }

    private var logoHeight: CGFloat {
        shrinkLogo ? 115 : 152.79259
    }

    // for appdev logo
    private func appDevLogoYOffset(for height: CGFloat) -> CGFloat {
        hasEntered ? 0 : height
    }

    // for animation
    private func startAnimation(for height: CGFloat) {
        guard height > 0 else { return }

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

#Preview {
    IntroAnimationView(logoNamespace: Namespace().wrappedValue) {}
}

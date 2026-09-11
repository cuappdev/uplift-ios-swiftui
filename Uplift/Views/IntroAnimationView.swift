import SwiftUI

struct IntroAnimationView: View {

    // MARK: - Properties

    @State private var hasEntered = false
    @State private var isFadingOut = false

    var onTransition: (() -> Void)?
    var onFinished: (() -> Void)?

    // MARK: - UI

    var body: some View {
           GeometryReader { geo in
               ZStack {
                   backgroundImage

                   ZStack(alignment: .bottom) {
                       Image("mountain_back")
                           .resizable()
                           .scaledToFill()
                           .frame(height: geo.size.height)
                           .frame(maxWidth: .infinity)
                           .clipped()
                           .offset(y: hasEntered ? 0 : geo.size.height)
                           .animation(.easeOut(duration: Constants.IntroAnimation.entranceDuration), value: hasEntered)

                       Image("mountain_front")
                           .resizable()
                           .scaledToFill()
                           .frame(height: geo.size.height)
                           .frame(maxWidth: .infinity)
                           .clipped()
                           .offset(y: hasEntered ? 50 : geo.size.height)
                           .animation(
                               .easeOut(duration: Constants.IntroAnimation.entranceDuration).delay(Constants.IntroAnimation.entranceDelay),
                               value: hasEntered
                           )

                       appDevLogo(in: geo)
                   }
                   .opacity(isFadingOut ? 0 : 1)
                   .animation(.easeInOut(duration: Constants.IntroAnimation.transitionDuration), value: isFadingOut)
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
                   .clipped()
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .ignoresSafeArea()
               .task {
                   await startAnimation(for: geo.size.height)
               }
           }
       }

    // MARK: - Views

    private var backgroundImage: some View {
        Image("intro_background")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .opacity(hasEntered && !isFadingOut ? 1 : 0)
            .animation(.easeInOut(duration: Constants.IntroAnimation.transitionDuration), value: isFadingOut)
    }

    private func appDevLogo(in geo: GeometryProxy) -> some View {
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
                .easeOut(duration: Constants.IntroAnimation.entranceDuration).delay(Constants.IntroAnimation.entranceDelay),
                value: hasEntered
            )
    }

    // MARK: - Helpers

    private func mountainYOffset(for height: CGFloat) -> CGFloat {
        hasEntered ? 0 : height
    }

    // for appdev logo
    private func appDevLogoYOffset(for height: CGFloat) -> CGFloat {
        hasEntered ? 0 : height
    }

    @MainActor
    private func startAnimation(for height: CGFloat) async {
        guard height > 0 else { return }

        hasEntered = true

        try? await Task.sleep(
            for: .seconds(Constants.IntroAnimation.introDuration)
        )

        withAnimation(
            .smooth(duration: Constants.IntroAnimation.transitionDuration)
        ) {
            isFadingOut = true
        }

        onTransition?()

        try? await Task.sleep(
            for: .seconds(Constants.IntroAnimation.transitionDuration)
        )

        onFinished?()
    }

}

#Preview {
    IntroAnimationView(onFinished: {})
}

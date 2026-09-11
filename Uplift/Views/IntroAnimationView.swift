import SwiftUI

struct IntroAnimationView: View {

    // MARK: - Properties

    @StateObject private var viewModel = IntroAnimationViewModel()

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
                           .offset(y: viewModel.hasEntered ? 0 : geo.size.height)
                           .animation(.easeOut(duration: Constants.IntroAnimation.entranceDuration), value: viewModel.hasEntered)

                       Image("mountain_front")
                           .resizable()
                           .scaledToFill()
                           .frame(height: geo.size.height)
                           .frame(maxWidth: .infinity)
                           .clipped()
                           .offset(y: viewModel.hasEntered ? 50 : geo.size.height)
                           .animation(
                               .easeOut(duration: Constants.IntroAnimation.entranceDuration).delay(Constants.IntroAnimation.entranceDelay),
                               value: viewModel.hasEntered
                           )

                       appDevLogo(in: geo)
                   }
                   .opacity(viewModel.isFadingOut ? 0 : 1)
                   .animation(.easeInOut(duration: Constants.IntroAnimation.transitionDuration), value: viewModel.isFadingOut)
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
                   .clipped()
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .ignoresSafeArea()
               .task {
                   await viewModel.startAnimation(
                       for: geo.size.height,
                       onTransition: onTransition,
                       onFinished: onFinished
                   )
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
            .opacity(viewModel.hasEntered && !viewModel.isFadingOut ? 1 : 0)
            .animation(.easeInOut(duration: Constants.IntroAnimation.transitionDuration), value: viewModel.isFadingOut)
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
            .offset(y: viewModel.appDevLogoYOffset(for: geo.size.height))
            .animation(
                .easeOut(duration: Constants.IntroAnimation.entranceDuration).delay(Constants.IntroAnimation.entranceDelay),
                value: viewModel.hasEntered
            )
    }

}

#Preview {
    IntroAnimationView(onFinished: {})
}

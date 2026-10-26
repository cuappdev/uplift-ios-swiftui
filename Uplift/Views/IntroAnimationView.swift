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
                   Constants.Images.mountainBack
                       .resizable()
                       .scaledToFill()
                       .frame(maxWidth: .infinity)
                       .clipped()
                       .offset(
                           y: viewModel.hasEntered ? 0 : geo.size.height
                       )
                       .animation(
                           .easeOut(
                            duration: Constants.IntroAnimation.entranceDuration
                           ),
                           value: viewModel.hasEntered
                       )

                   Constants.Images.mountainFront
                       .resizable()
                       .scaledToFill()
                       .frame(maxWidth: .infinity)
                       .clipped()
                       .offset(
                        y: viewModel.hasEntered ? 0 : geo.size.height
                       )
                       .animation(
                           .easeOut(
                            duration: Constants.IntroAnimation.entranceDuration
                           )
                           .delay(Constants.IntroAnimation.entranceDelay),
                           value: viewModel.hasEntered
                       )

                   appDevLogo(in: geo)
               }
               .opacity(viewModel.isFadingOut ? 0 : 1)
               .animation(
                   .easeInOut(
                    duration: Constants.IntroAnimation.transitionDuration
                   ),
                   value: viewModel.isFadingOut
               )
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
        Constants.Images.introBackground
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .opacity(viewModel.hasEntered && !viewModel.isFadingOut ? 1 : 0)
            .animation(.easeInOut(duration: Constants.IntroAnimation.transitionDuration), value: viewModel.isFadingOut)
    }

    private func appDevLogo(in geo: GeometryProxy) -> some View {
        Constants.Images.appDevLogoWhite
            .resizable()
            .scaledToFit()
            .frame(
                width: Constants.IntroAnimation.appDevLogoWidth,
                height: Constants.IntroAnimation.appDevLogoHeight
            )
            .opacity(viewModel.hasEntered ? 1 : 0)
            .animation(
                .easeOut(
                    duration: Constants.IntroAnimation.entranceDuration
                )
                .delay(Constants.IntroAnimation.entranceDelay),
                value: viewModel.hasEntered
            )
            .padding(Constants.IntroAnimation.appDevLogoPadding)
    }

}

#Preview {
    IntroAnimationView(onFinished: {})
}

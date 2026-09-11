import SwiftUI

struct IntroAnimationView: View {

    // MARK: - Properties

    @StateObject private var viewModel = IntroAnimationViewModel()

    var onTransition: (() -> Void)?
    var onFinished: (() -> Void)?

    // MARK: - Constants

    private let entranceDuration: Double = 1.0
    private let entranceDelay: Double = 0.1

    private let mountainFrontYOffset: CGFloat = 50

    private let appDevLogoWidth: CGFloat = 164
    private let appDevLogoHeight: CGFloat = 24
    private let appDevLogoVerticalPositionMultiplier: CGFloat = 1.2

    // MARK: - UI

    var body: some View {
       GeometryReader { geo in
           ZStack {
               backgroundImage

               ZStack(alignment: .bottom) {
                   Constants.Images.mountainBack
                       .resizable()
                       .scaledToFill()
                       .frame(height: geo.size.height)
                       .frame(maxWidth: .infinity)
                       .clipped()
                       .offset(
                           y: viewModel.hasEntered ? 0 : geo.size.height
                       )
                       .animation(
                           .easeOut(
                               duration: entranceDuration
                           ),
                           value: viewModel.hasEntered
                       )

                   Constants.Images.mountainFront
                       .resizable()
                       .scaledToFill()
                       .frame(height: geo.size.height)
                       .frame(maxWidth: .infinity)
                       .clipped()
                       .offset(
                           y: viewModel.hasEntered ? mountainFrontYOffset : geo.size.height
                       )
                       .animation(
                           .easeOut(
                               duration: entranceDuration
                           )
                           .delay(entranceDelay),
                           value: viewModel.hasEntered
                       )

                   appDevLogo(in: geo)
               }
               .opacity(viewModel.isFadingOut ? 0 : 1)
               .animation(
                   .easeInOut(
                    duration: viewModel.transitionDuration
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
            .animation(.easeInOut(duration: viewModel.transitionDuration), value: viewModel.isFadingOut)
    }

    private func appDevLogo(in geo: GeometryProxy) -> some View {
        Constants.Images.appDevLogoWhite
            .resizable()
            .scaledToFit()
            .frame(
                width: appDevLogoWidth,
                height: appDevLogoHeight
            )
            .position(
                x: geo.size.width / 2,
                y: geo.size.height * appDevLogoVerticalPositionMultiplier
            )
            .offset(y: viewModel.appDevLogoYOffset(for: geo.size.height))
            .animation(
                .easeOut(
                    duration: entranceDuration
                )
                .delay(entranceDelay),
                value: viewModel.hasEntered
            )
    }

}

#Preview {
    IntroAnimationView(onFinished: {})
}

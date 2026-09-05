import SwiftUI

struct IntroAnimationView: View {
    @State private var hasEntered = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("intro_background")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .opacity(hasEntered ? 1 : 0)
                    .animation(.easeIn(duration: 1.2), value: hasEntered)
                
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
                        .opacity(hasEntered ? 1 : 0)
                        .animation(.easeIn(duration: 1.2), value: hasEntered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 173.14737, height: 152.79259)
                    .offset(
                        y: hasEntered ? -geo.size.height * 0.22 : geo.size.height
                    )
                
                    .animation(.easeOut(duration: 1.0), value: hasEntered)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Constants.Colors.white)
            .ignoresSafeArea()
            .onAppear {
                hasEntered = true
            }
        }
    }
}

#Preview {
    IntroAnimationView()
}

import SwiftUI

struct WorkoutProgressArc: View {
    let workCompleted: Int // m = number of completed workouts
    let totalWork: Int // n = number of work days
    let width: CGFloat = 231
    let height: CGFloat = 120
    let radius: CGFloat = 125.5

    // Calculate progress percentage
    private var progress: Double {
        guard totalWork > 0 else { return 0 }
        return Double(workCompleted) / Double(totalWork)
    }

    // Calculate the end angle for the progress arc
    private var endAngle: Double {
        180 - (progress * 180)
    }

    var body: some View {
        VStack {
            ZStack {
                // Background arc (empty progress)
                Arc(startAngle: .degrees(180), endAngle: .degrees(0))
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: width, height: height)

                // Progress arc
                Arc(startAngle: .degrees(180), endAngle: .degrees(180 + (180 - endAngle)))
                    .stroke(Color.blue, lineWidth: 8)
                    .frame(width: width, height: height)

                if progress > 0 {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                        .position(
                            x: width / 2 + cos(Double.pi * (1 - progress)) * radius,
                            y: height - sin(Double.pi * (1 - progress)) * radius
                        )
                }
                // Status text in center below the arc
                VStack {
                    Text("\(workCompleted)/\(totalWork)")
                        .font(.system(size: 36, weight: .bold))

                    Text("Workouts this week")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .position(x: width / 2, y: height + 60)
            }
            .frame(width: width, height: height + 120)
            .onAppear(){
                print(endAngle)
            }
        }
    }
}

// Custom Arc shape
struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.height)
        let radius = min(rect.width, rect.height * 2) / 2

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )

        return path
    }
}

#Preview{
    WorkoutProgressArc(workCompleted: 4, totalWork: 7)
}

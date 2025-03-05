//
//  ProfileView.swift
//  Uplift
//
//  Created by jiwon jeong on 2/27/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//
import SwiftUI
import Kingfisher
/// The main view for the Profile page.
struct ProfileView: View {
    // MARK: - Properties
    @EnvironmentObject var tabBarProp: TabBarProperty
    @StateObject private var viewModel = ViewModel()
    // MARK: - UI
    var body: some View {
        NavigationStack {
            VStack {
                header
                scrollContent
            }
            .background(Constants.Colors.white)
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
    }
    private var header: some View {
        VStack {
            Spacer()
            HStack {
                Text("Profile")
                    .foregroundStyle(Constants.Colors.black) // is there a colors thingy I can use richie
                    .font(Constants.Fonts.h1)
                Spacer()
                settingsButton // is this bad
            }
        }
        .padding(
            EdgeInsets(
                top: 0,
                leading: Constants.Padding.homeHorizontal,
                bottom: 12,
                trailing: Constants.Padding.homeHorizontal
            )
        )
        .background(
            Constants.Colors.white
                .upliftShadow(Constants.Shadows.smallLight)
        )
        .ignoresSafeArea(.all)
        .frame(height: 64)
    }
    private var settingsButton: some View {
        Button {
            viewModel.showSettingsSheet = true
        } label: {
            Constants.Images.camera
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24) // can I use this or is this bad do I need fixed weights
                .foregroundStyle(Constants.Colors.black)
        }
        .sheet(isPresented: $viewModel.showSettingsSheet) {
            settingsView
        }
    }
    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                profileHeader
                DividerLine() // is this bad richie
                statsSection
                DividerLine()
                workoutHistorySection
                DividerLine()
                fitnessGoalsSection
            }
            .padding(.horizontal, Constants.Padding.homeHorizontal)
            .padding(.bottom, 32 + Constants.Padding.tabBarHeight)
        }
        .refreshable {
            viewModel.fetchUserProfile()
        }
    }
    private var profileHeader: some View {
        HStack(spacing: 20) {
            profileImage
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.profile?.name ?? "Your Name")
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)
                Text(viewModel.profile?.netID ?? "net_id")
                    .font(Constants.Fonts.bodyLight)
                    .foregroundStyle(Constants.Colors.gray03)
                Text("Member since \(viewModel.profile?.joinedDate.dateStringLongMonth ?? "January 2025")")
                    .font(Constants.Fonts.labelLight)
                    .foregroundStyle(Constants.Colors.gray03)
                    .padding(.top, 4)
            }
            Spacer()
        }
        .padding(.vertical, 16)
    }
    private var profileImage: some View {
        Group {
            Circle()
                .fill(Constants.Colors.gray01)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(viewModel.profile?.initials ?? "YN")
                        .font(Constants.Fonts.h1)
                        .foregroundStyle(Constants.Colors.gray03)
                )
                .upliftShadow(Constants.Shadows.smallLight)
        }
    }
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("YOUR STATS")
                .font(Constants.Fonts.h2)
                .foregroundStyle(Constants.Colors.black)
            HStack(spacing: 16) {
                statCard(title: "Gym Visits", value: "\(viewModel.profile?.gymVisits ?? 0)")
                statCard(title: "Classes Attended", value: "\(viewModel.profile?.classesAttended ?? 0)")
            }
            HStack(spacing: 16) {
                statCard(title: "Weekly Avg", value: "\(viewModel.profile?.weeklyAvgVisits ?? 0) visits")
                statCard(title: "Streak", value: "\(viewModel.profile?.streak ?? 0) days")
            }
        }
        .padding(.vertical, 16)
    }
    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Constants.Fonts.bodyLight)
                .foregroundStyle(Constants.Colors.gray03)
            Text(value)
                .font(Constants.Fonts.f2)
                .foregroundStyle(Constants.Colors.black)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Constants.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
                .upliftShadow(Constants.Shadows.smallLight)
        )
    }
    private var workoutHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("WORKOUT HISTORY")
                    .font(Constants.Fonts.h2)
                    .foregroundStyle(Constants.Colors.black)
                Spacer()
                Button {
                    viewModel.showFullHistory = true
                } label: {
                    Text("See All")
                        .font(Constants.Fonts.labelSemibold)
                        .foregroundStyle(Constants.Colors.gray04)
                        .underline()
                }
            }
            if viewModel.workoutHistory.isEmpty {
                emptyHistoryView
            } else {
                ForEach(viewModel.workoutHistory.prefix(3), id: \.id) { workout in
                    workoutHistoryCard(workout: workout)
                }
            }
        }
        .padding(.vertical, 16)
    }
    private var emptyHistoryView: some View {
        VStack(spacing: 16) {
            Constants.Images.greenTea //im using random symbols is that fine
                .padding(24)
            Text("No workout history yet")
                .font(Constants.Fonts.bodyMedium)
                .foregroundStyle(Constants.Colors.black)
            Text("Your workout sessions will appear here")
                .font(Constants.Fonts.bodyLight)
                .foregroundStyle(Constants.Colors.gray03)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
    }
    private func workoutHistoryCard(workout: WorkoutHistory) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text(workout.date.dateStringDayMonth)
                    .font(Constants.Fonts.f2)
                    .foregroundStyle(Constants.Colors.black)
                Text(workout.location)
                    .font(Constants.Fonts.labelLight)
                    .foregroundStyle(Constants.Colors.gray03)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(workout.duration) min")
                    .font(Constants.Fonts.f2)
                    .foregroundStyle(Constants.Colors.black)
                Text(workout.time)
                    .font(Constants.Fonts.labelLight)
                    .foregroundStyle(Constants.Colors.gray03)
            }
        }
        .padding(16)
        .background(Constants.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
                .upliftShadow(Constants.Shadows.smallLight)
        )
    }
    private var fitnessGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("FITNESS GOALS")
                    .font(Constants.Fonts.h2)
                    .foregroundStyle(Constants.Colors.black)
                Spacer()
                Button {
                    viewModel.showAddGoalSheet = true
                } label: {
                    Constants.Images.camera
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Constants.Colors.black)
                }
                .sheet(isPresented: $viewModel.showAddGoalSheet) {
                    addGoalView
                }
            }
            if viewModel.fitnessGoals.isEmpty {
                emptyGoalsView
            } else {
                ForEach(viewModel.fitnessGoals, id: \.id) { goal in
                    fitnessGoalCard(goal: goal)
                }
            }
        }
        .padding(.vertical, 16)
    }
    private var emptyGoalsView: some View {
        VStack(spacing: 16) {
            Constants.Images.goal // whatever icon this is
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(Constants.Colors.gray03)
                .padding(24)
            Text("No fitness goals yet")
                .font(Constants.Fonts.bodyMedium)
                .foregroundStyle(Constants.Colors.black)
            Text("Add goals to track your progress")
                .font(Constants.Fonts.bodyLight)
                .foregroundStyle(Constants.Colors.gray03)
            Button {
                viewModel.showAddGoalSheet = true
            } label: {
                Text("Add Goal")
                    .font(Constants.Fonts.h3)
                    .foregroundStyle(Constants.Colors.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Constants.Colors.yellow)
                    .cornerRadius(38)
                    .upliftShadow(Constants.Shadows.smallLight)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
    }
    private func fitnessGoalCard(goal: FitnessGoal) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.title)
                    .font(Constants.Fonts.f2)
                    .foregroundStyle(Constants.Colors.black)
                Spacer()
                Text("\(goal.currentProgress)/\(goal.target) \(goal.unit)")
                    .font(Constants.Fonts.bodyMedium)
                    .foregroundStyle(Constants.Colors.black)
            }
            ProgressView(value: goal.progressPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: Constants.Colors.yellow))
                .frame(height: 8)
            HStack {
                Text("Target: \(goal.targetDate.dateStringDayMonth)")
                    .font(Constants.Fonts.labelLight)
                    .foregroundStyle(Constants.Colors.gray03)
                Spacer()
                Text("\(Int(goal.progressPercentage * 100))% Complete")
                    .font(Constants.Fonts.labelLight)
                    .foregroundStyle(Constants.Colors.gray03)
            }
        }
        .padding(16)
        .background(Constants.Colors.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray01, lineWidth: 1)
                .upliftShadow(Constants.Shadows.smallLight)
        )
    }
    // Modal Views
    private var settingsView: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Settings")
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)
                Spacer()
                Button {
                    viewModel.showSettingsSheet = false
                } label: {
                    Constants.Images.cross
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.black)
                }
            }
            .padding(.top, 24)
            DividerLine()
            Button {
                // Edit profile action
            } label: {
                HStack {
                    Text("Edit Profile")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.gray03)
                }
            }
            DividerLine()
            Button {
                // Privacy policy action
            } label: {
                HStack {
                    Text("Privacy Policy")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.gray03)
                }
            }
            DividerLine()
            Button {
                // Terms of service action
            } label: {
                HStack {
                    Text("Terms of Service")
                        .font(Constants.Fonts.bodyNormal)
                        .foregroundStyle(Constants.Colors.black)
                    Spacer()
                    Constants.Images.arrowLeft
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.gray03)
                }
            }
            DividerLine()
            Button {
                viewModel.logOut()
            } label: {
                Text("Log Out")
                    .font(Constants.Fonts.bodyNormal)
                    .foregroundStyle(Constants.Colors.closed)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Constants.Colors.white)
    }
    private var addGoalView: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Add New Goal")
                    .font(Constants.Fonts.h1)
                    .foregroundStyle(Constants.Colors.black)
                Spacer()
                Button {
                    viewModel.showAddGoalSheet = false
                } label: {
                    Constants.Images.cross
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Constants.Colors.black)
                }
            }
            .padding(.top, 24)
            DividerLine()
            Text("Coming soon!")
                .font(Constants.Fonts.bodyMedium)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(24)
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Constants.Colors.white)
    }
}
// MARK: - ViewModel
extension ProfileView {
    class ViewModel: ObservableObject {
        @Published var fitnessGoals: [FitnessGoal] = []
        @Published var profile: UserProfile?
        @Published var showAddGoalSheet = false
        @Published var showFullHistory = false
        @Published var showSettingsSheet = false
        @Published var workoutHistory: [WorkoutHistory] = []
        func fetchUserProfile() {
            // Simulate network fetch with mock data
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.profile = UserProfile(
                    id: "user123",
                    name: "Jane Smith",
                    netID: "js123",
                    email: "js123@cornell.edu",
                    profileImageUrl: nil,
                    joinedDate: Date().addingTimeInterval(-5184000), // 60 days ago
                    gymVisits: 42,
                    classesAttended: 15,
                    weeklyAvgVisits: 3.5,
                    streak: 5
                )
                self.workoutHistory = [
                    WorkoutHistory(
                        id: "workout1",
                        date: Date().addingTimeInterval(-86400), // Yesterday
                        location: "Helen Newman Fitness Center",
                        time: "3:30 PM - 5:00 PM",
                        duration: 90
                    ),
                    WorkoutHistory(
                        id: "workout2",
                        date: Date().addingTimeInterval(-259200), // 3 days ago
                        location: "Teagle Up",
                        time: "4:15 PM - 5:45 PM",
                        duration: 90
                    ),
                    WorkoutHistory(
                        id: "workout3",
                        date: Date().addingTimeInterval(-432000), // 5 days ago
                        location: "Morrison Fitness Center",
                        time: "9:00 AM - 10:30 AM",
                        duration: 90
                    )
                ]
                self.fitnessGoals = [
                    FitnessGoal(
                        id: "goal1",
                        title: "Weekly Gym Visits",
                        target: 5,
                        currentProgress: 3,
                        unit: "visits",
                        targetDate: Date().addingTimeInterval(604800), // 1 week later
                        progressPercentage: 0.6
                    ),
                    FitnessGoal(
                        id: "goal2",
                        title: "Monthly Classes",
                        target: 12,
                        currentProgress: 4,
                        unit: "classes",
                        targetDate: Date().addingTimeInterval(2592000), // 30 days later
                        progressPercentage: 0.33
                    )
                ]
            }
        }
        func logOut() {
                showSettingsSheet = false
        }
    }
}
// MARK: - Supporting Models
struct UserProfile {
    let id: String
    let name: String
    let netID: String
    let email: String
    let profileImageUrl: URL?
    let joinedDate: Date
    let gymVisits: Int
    let classesAttended: Int
    let weeklyAvgVisits: Double
    let streak: Int
    var initials: String {
        let components = name.components(separatedBy: " ")
        if components.count >= 2,
           let first = components.first?.first,
           let last = components.last?.first {
            return "\(first)\(last)"
        } else if let first = name.first {
            return String(first)
        }
        return ""
    }
}
struct WorkoutHistory: Identifiable {
    let id: String
    let date: Date
    let location: String
    let time: String
    let duration: Int
}
struct FitnessGoal: Identifiable {
    let id: String
    let title: String
    let target: Int
    let currentProgress: Int
    let unit: String
    let targetDate: Date
    let progressPercentage: Double
}
// do we have an extension of a date richie
extension Date {
    var dateStringLongMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
}
#Preview{
    ProfileView()
}

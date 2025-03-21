//
//  WeeklyWorkoutData.swift
//  Uplift
//
//  Created by jiwon jeong on 3/16/25.
//  Copyright © 2025 Cornell AppDev. All rights reserved.
//

import Foundation

struct WeeklyWorkoutData {
    var currentWeekWorkouts: Int
    var weeklyGoal: Int
    var weekDates: [Date]

    var progressPercentage: Double {
        Double(currentWeekWorkouts) / Double(weeklyGoal)
    }
}

//
//  TimeFormat.swift
//  AVPlayer
//
//  Created by  user on 2018/7/11.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

extension Double {
    var intValue: Int {
        return Int(self)
    }
}

struct TimeFormat {
    private(set) var seconds = 0
    private(set) var mins = 0
    private(set) var hours = 0
    private(set) var days = 0
    private(set) var totalSeconds: TimeInterval = 0
    private(set) var timeFormatString = ""

    init(totalSeconds: TimeInterval) {
        self.totalSeconds = totalSeconds
        let value = TimeFormat.countTime(totalSeconds: totalSeconds)
        days = value.days
        hours = value.hours
        mins = value.mins
        seconds = value.seconds
        timeFormatString = value.timeStr
    }

    static func timeFormatString(totalSeconds: TimeInterval) -> String {
        return countTime(totalSeconds: totalSeconds).timeStr
    }

    private static func countTime(totalSeconds: TimeInterval) -> (seconds: Int, mins: Int, hours: Int, days: Int, timeStr: String) {
        let allSeconds = round(totalSeconds)

        let days = (allSeconds / (3600 * 24)).intValue
        let daysLeft = allSeconds - Double(days) * 3600 * 24

        let hours = (daysLeft / 3600).intValue
        let hoursLeft = daysLeft - Double(hours) * 3600

        let mins = (hoursLeft / 60).intValue
        let minsLeft = hoursLeft - Double(mins) * 60

        let seconds = minsLeft.intValue

        var timeStr = String(format: "%02d", seconds)
        if mins > 0 {
            timeStr = String(format: "%02d", mins) + ":" + timeStr
        } else {
            timeStr = "00:" + timeStr
        }

        if hours > 0 {
            timeStr = String(format: "%02d", hours) + ":" + timeStr
        }

        if days > 0 {
            timeStr = "\(days)" + ":" + timeStr
        }
        return (seconds, mins, hours, days, timeStr)
    }
}

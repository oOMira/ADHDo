//
//  Feed+AdvertList.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 30.11.25.
//

import Foundation

extension Feed {
    private static let defaultDate: Date = {
        let utcCalendar = Calendar(identifier: .gregorian)
        let utcComponents = DateComponents(calendar: utcCalendar, timeZone: TimeZone(secondsFromGMT: 0),
                                           year: 2023, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        return utcCalendar.date(from: utcComponents) ?? .init()
    }()
    
    static let advertList: [AdvertConfiguration] = [
        .init(date: defaultDate, title: "Clean up the living room", description: "Just tidy up and organize."),
        .init(date: defaultDate, title: "Clean up the kitchen", description: "Just tidy up and organize."),
        .init(date: defaultDate, title: "Clean up the workplace", description: "Just tidy up and organize."),
        .init(date: defaultDate, title: "Clean up the bed room", description: "Just tidy up and organize."),
        .init(date: defaultDate, title: "Clean up the wardrobe", description: "Just tidy up and organize."),
        .init(date: defaultDate, title: "Clean up the car", description: "Just tidy up and organize."),
    ]
}

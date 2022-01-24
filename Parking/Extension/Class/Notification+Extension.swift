//
//  Notification.swift
//  Parking
//
//  Created by Genapi on 23/01/2022.
//

import Foundation

enum NotificationName: String {
    case bikeIsRequesting
    case bikeIsDone
    case bikeHasNewData
    case carIsRequesting
    case carIsDone
    case carHasNewData
    case carIsReadyToCount
}

extension Notification.Name {
    static let bikeIsRequesting = Notification.Name(NotificationName.bikeIsRequesting.rawValue)
    static let bikeIsDone = Notification.Name(NotificationName.bikeIsDone.rawValue)
    static let bikeHasNewData = Notification.Name(NotificationName.bikeHasNewData.rawValue)
    static let carIsRequesting = Notification.Name(NotificationName.carIsRequesting.rawValue)
    static let carIsDone = Notification.Name(NotificationName.carIsDone.rawValue)
    static let carHasNewData = Notification.Name(NotificationName.carHasNewData.rawValue)
    static let carIsReadyToCount = Notification.Name(NotificationName.carIsReadyToCount.rawValue)
}

extension Notification {
    static let bikeIsRequesting = Notification(name: Notification.Name(rawValue: NotificationName.bikeIsRequesting.rawValue))
    static let bikeIsDone = Notification(name: Notification.Name(rawValue: NotificationName.bikeIsDone.rawValue))
    static let bikeHasNewData = Notification(name: Notification.Name(rawValue: NotificationName.bikeHasNewData.rawValue))
    static let carIsRequesting = Notification(name: Notification.Name(rawValue: NotificationName.carIsRequesting.rawValue))
    static let carIsDone = Notification(name: Notification.Name(rawValue: NotificationName.carIsDone.rawValue))
    static let carHasNewData = Notification(name: Notification.Name(rawValue: NotificationName.carHasNewData.rawValue))
    static let carIsReadyToCount = Notification(name: Notification.Name(rawValue: NotificationName.carIsReadyToCount.rawValue))
}

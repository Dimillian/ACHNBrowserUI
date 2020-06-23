//
//  NotificationsManager.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 29/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import UserNotifications

public class NotificationManager: NSObject {
    public static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    public func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (_, _) in
            
        }
    }
    
    public func removePendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    public func registerTurnipsPredictionNotification(prediction: TurnipPredictions) {
        removePendingNotifications()
        if let average = prediction.averagePrices, let minMax = prediction.minMax {
            var dayOfTheWeek = 2
            let today = Calendar.current.component(.weekday, from: Date())
            for (index, day) in average.enumerated() {
                let isMorning = index % 2 == 0
                
                let min = minMax[index].first!
                let max = minMax[index].last!
                
                if dayOfTheWeek >= today {
                    let content = UNMutableNotificationContent()
                    content.title = NSLocalizedString("Turnip prices", comment: "")
                    let timeString = isMorning ? NSLocalizedString("this morning", comment: "") : NSLocalizedString("this afternoon", comment: "")
                    content.body = String.init(format: NSLocalizedString("Your prices predictions for %@ should be around %lld bells. With a minimum of %lld and a maximum of %lld.", comment: ""),
                                               timeString, day, min, max)
                    
                    var components = DateComponents()
                    components.calendar = Calendar(identifier: .gregorian)
                    components.weekday = dayOfTheWeek
                    components.hour = isMorning ? 8 : 12
                    
                    registerNotification(content: content, date: components)
                }
                
                if !isMorning {
                    dayOfTheWeek += 1
                }
            }
            
            registerReminderNotifications()
        }
    }
    
    public func testNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Turnip prices (test)", comment: "")
        content.body = NSLocalizedString("Your prices predictions for this morning should be around 100 bells. With a minimum of 50 and a maximum of 650.", comment: "")
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error while registering notification: \(error.localizedDescription)")
            }
        }
        
    }
    
    private func registerReminderNotifications() {
        var content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Friendly reminder", comment: "")
        content.body = NSLocalizedString("It's time to buy turnips and add the buy price in the app.", comment: "")
        
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.weekday = 1
        components.hour = 9
        
        registerNotification(content: content, date: components)
        
        content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Friendly reminder", comment: "")
        content.body = NSLocalizedString("It's the start of the week, don't forget to add your store buy prices in the app as you play the game. You'll get more accurate predictions.", comment: "")
        
        components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.weekday = 2
        components.hour = 9
        
        registerNotification(content: content, date: components)
    }
    
    private func registerNotification(content: UNMutableNotificationContent, date: DateComponents) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error while registering notification: \(error.localizedDescription)")
            }
        }
    }
    
    public func pendingNotifications(completion: @escaping (([UNNotificationRequest]) -> Void)) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.list)
    }
}

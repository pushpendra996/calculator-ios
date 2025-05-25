//
//  calculator_iosApp.swift
//  calculator-ios
//
//  Created by Pushpendra on 24/05/25.
//

import SwiftUI

@main
struct calculator_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            CalculatorScreen()
        }
    }
}

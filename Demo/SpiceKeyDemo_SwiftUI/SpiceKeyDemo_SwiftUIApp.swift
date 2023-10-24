/*
 SpiceKeyDemo_SwiftUIApp.swift
 SpiceKeyDemo_SwiftUI

 Created by Takuto Nakamura on 2022/06/29.
*/

import SwiftUI
import AppKit

@main
struct SpiceKeyDemo_SwiftUIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

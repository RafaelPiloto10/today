//
//  todayApp.swift
//  today
//
//  Created by Rafael on 1/6/24.
//

import SwiftUI

@main
struct todayApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        init() {
          AppDelegate.shared = self.appDelegate
        }
    
        var body: some Scene {
            Settings{
                EmptyView()
            }
        }
    }
    class AppDelegate: NSObject, NSApplicationDelegate {
        var popover = NSPopover.init()
        var statusBarItem: NSStatusItem?
        static var shared : AppDelegate!
        func applicationDidFinishLaunching(_ notification: Notification) {
            
            let contentView = ContentView()

            popover.behavior = .transient
            popover.animates = false
            popover.contentViewController = NSViewController()
            popover.contentViewController?.view = NSHostingView(rootView: contentView)
            popover.contentViewController?.view.window?.makeKey()
            statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem?.button?.title = "!"
            statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
        }
        @objc func showPopover(_ sender: AnyObject?) {
            if let button = statusBarItem?.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
        @objc func closePopover(_ sender: AnyObject?) {
            popover.performClose(sender)
        }
        @objc func togglePopover(_ sender: AnyObject?) {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        }
    }

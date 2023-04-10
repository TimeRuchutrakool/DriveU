//
//  DriveUApp.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

@main
struct DriveUApp: App {
    @StateObject var locationSearchViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(locationSearchViewModel)
        }
    }
}

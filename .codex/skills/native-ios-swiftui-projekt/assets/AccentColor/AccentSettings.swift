//
//  AccentSettings.swift
//  ios-webview-app
//
//  Created by Christoph Huschenhöfer on 22.04.26.
//

import SwiftUI
import Combine

final class AccentSettings: ObservableObject {
    @Published var accentSettings: Int = UserDefaults.standard.integer(forKey: "Accent") {
        didSet {
            UserDefaults.standard.set(self.accentSettings, forKey: "Accent")
        }
    }

    private init() {}
    public static let shared = AccentSettings()
}

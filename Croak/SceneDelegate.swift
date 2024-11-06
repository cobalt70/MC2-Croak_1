////
////  SceneDelegate.swift
////  Croak
////
////  Created by jeong hyein on 5/15/24.
////
//
//import UIKit
//import SwiftUI
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        let window = UIWindow(windowScene: windowScene)
//        let contentView = MainView()
//        window.rootViewController = UIHostingController(rootView: contentView)
//        self.window = window
//        window.makeKeyAndVisible()
//    }
//
//    func sceneDidEnterBackground(_ scene: UIScene) {
//        print("A")
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.saveDataToSwiftData()
//    }
//}

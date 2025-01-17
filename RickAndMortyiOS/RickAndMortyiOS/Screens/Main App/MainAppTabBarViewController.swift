//
//  MainAppTabBarViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import UIKit
import SwiftUI

class MainAppTabBarViewController: UITabBarController {

    let locationsVC = UIHostingController(rootView: LocationsView())
    let episodesVC = UIHostingController(rootView: EpisodesView())
    let charactersVC = UIHostingController(rootView: CharactersView())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTabBar()
    }
    
    func configureUITabBarItems(){
        charactersVC.tabBarItem = UITabBarItem(title: "Characters", image: SFSymbols.charactersSymbol, tag: 0)
        locationsVC.tabBarItem = UITabBarItem(title: "Locations", image: SFSymbols.locationsSymbol, tag: 1)
        episodesVC.tabBarItem = UITabBarItem(title: "Episodes", image: SFSymbols.episodesSymbol, tag: 2)
    }
    
    func configureTabBar(){
        tabBar.tintColor = .rickBlue
        setViewControllers([charactersVC, locationsVC, episodesVC], animated: true)
    }

}

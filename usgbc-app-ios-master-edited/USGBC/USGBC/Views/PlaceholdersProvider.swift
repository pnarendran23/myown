//
//  PlaceholdersProvider.swift
//  USGBC
//
//  Created by Vishal Raj on 23/11/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import HGPlaceholders

extension PlaceholdersProvider {
    static var summer: PlaceholdersProvider {
        var commonStyle = PlaceholderStyle()
        commonStyle.backgroundColor = UIColor(red: 1.0, green: 236.0/255, blue: 209.0/255.0, alpha: 1.0)
        commonStyle.actionBackgroundColor = .black
        commonStyle.actionTitleColor = .white
        commonStyle.titleColor = .black
        commonStyle.isAnimated = false
        
        var loadingStyle = commonStyle
        loadingStyle.actionBackgroundColor = .clear
        loadingStyle.actionTitleColor = .gray
        
        var loadingData: PlaceholderData = .loading
        loadingData.image = #imageLiteral(resourceName: "logo-usgbc-gray")
        let loading = Placeholder(data: loadingData, style: loadingStyle, key: .loadingKey)
        
        var errorData: PlaceholderData = .error
        errorData.image = #imageLiteral(resourceName: "logo-usgbc-gray")
        let error = Placeholder(data: errorData, style: commonStyle, key: .errorKey)
        
        var noResultsData: PlaceholderData = .noResults
        noResultsData.image = #imageLiteral(resourceName: "logo-usgbc-gray")
        let noResults = Placeholder(data: noResultsData, style: commonStyle, key: .noResultsKey)
        
        var noConnectionData: PlaceholderData = .noConnection
        noConnectionData.image = #imageLiteral(resourceName: "logo-usgbc-gray")
        let noConnection = Placeholder(data: noConnectionData, style: commonStyle, key: .noConnectionKey)
        
        let placeholdersProvider = PlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        
        let xibPlaceholder = Placeholder(cellIdentifier: "CustomPlaceholderCell", key: PlaceholderKey.custom(key: "XIB"))
        
        placeholdersProvider.add(placeholders: PlaceholdersProvider.starWarsPlaceholder, xibPlaceholder)
        
        return placeholdersProvider
    }
    
    private static var starWarsPlaceholder: Placeholder {
        var starwarsStyle = PlaceholderStyle()
        starwarsStyle.backgroundColor = .clear
        //starwarsStyle.actionBackgroundColor = .clear
        //starwarsStyle.actionTitleColor = .white
        starwarsStyle.titleColor = .darkGray
        starwarsStyle.isAnimated = true
        
        var starwarsData = PlaceholderData()
        starwarsData.title = NSLocalizedString("Nothing found!", comment: "")
        //starwarsData.subtitle = NSLocalizedString("Star Wars", comment: "")
        starwarsData.image = #imageLiteral(resourceName: "usgbc")
        //starwarsData.action = NSLocalizedString("OK!", comment: "")
        
        let placeholder = Placeholder(data: starwarsData, style: starwarsStyle, key: PlaceholderKey.custom(key: "starWars"))
        
        return placeholder
    }
}

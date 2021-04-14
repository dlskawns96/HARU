//
//  LocationViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/14.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mapView: MKMapView!
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = .address
        self.searchBar.delegate = self
//        self.searchResultTable.dataSource = self
//        self.searchResultTable.delegate = self
    }
}

extension LocationViewController: UISearchBarDelegate {
    
}

extension LocationViewController: MKLocalSearchCompleterDelegate {
    
}

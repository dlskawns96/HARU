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
    @IBOutlet var searchResultTable: UITableView!
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    var delegate: LocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        self.searchCompleter.delegate = self
//        self.searchCompleter.resultTypes = .address
        self.searchBar.delegate = self
        self.searchResultTable.dataSource = self
        self.searchResultTable.delegate = self
    }
}

protocol LocationViewControllerDelegate {
    func searchFinished(mapItem: MKMapItem, name: String)
}

extension LocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchResultTable.reloadData()
        }

        // 입력을 자동완성 대상에 넣기
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationViewController: MKLocalSearchCompleterDelegate {
    
    // 자동완성 결과를 받는 함수
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTable.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        return cell
    }
    
    // 선택한 위치정보 가져오기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: { (response, error) in
            guard error == nil else {
                print("Search Error Occured")
                return
            }
            guard let placeMark = response?.mapItems[0].placemark else { return }
            let mapItem = MKMapItem(placemark: placeMark)
            self.delegate?.searchFinished(mapItem: mapItem, name: "\(selectedResult.title)")
            self.navigationController?.popViewController(animated: true)
        })
    }
}

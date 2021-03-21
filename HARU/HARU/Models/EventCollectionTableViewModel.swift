//
//  EventCollectionTableViewModel.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/07.
//

import Foundation
import EventKit

class EventCollectionTableViewModel {
    weak var delegate: EventCollectionTableViewModelDelegate?
    
    func requestData(ofYear date: Date) {
        var dataArray = [[EventCollectionTableViewItem]]()
        let calendarLoader = CalendarLoader()
        let events = calendarLoader.loadEvents(ofYear: date)
        for month in 0...11 {
            dataArray.append([])
            for event in events[month] {
                let item = EventCollectionTableViewItem(event: event)
                dataArray[month].append(item)
            }
        }
        print(dataArray.count)
        delegate?.didLoadData(data: dataArray)
    }
}

protocol EventCollectionTableViewModelDelegate: class {
    func didLoadData(data: [[EventCollectionTableViewItem]])
}

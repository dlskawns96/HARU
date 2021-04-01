//
//  AddEventTableItems.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/18.
//

import Foundation

class TextFieldItem: AddEventCellItem {
    var itemType: ItemType = .textFieldItem
    var titleString: String
    
    init(title: String) {
        self.titleString = title
    }
}

class TextItem: AddEventCellItem {
    var itemType: ItemType = .textItem
    var isStartDate = false
    var titleString: String
    init(isStartDate: Bool, title: String) {
        self.isStartDate = isStartDate
        titleString = title
    }
}

class CalendarItem: AddEventCellItem {
    var itemType: ItemType = .calendarItem
    var titleString: String
    
    init(title: String) {
        self.titleString = title
    }
    
}

class SwitchItem: AddEventCellItem {
    var itemType: ItemType = .switchItem
    var titleString: String
    
    init(title: String) {
        self.titleString = title
    }
}

class CalendarEditItem: AddEventCellItem {
    var itemType: ItemType = .calendarEditItem
    var titleString: String
    
    init(title: String) {
        self.titleString = title
    }
}

class EventNoteItem: AddEventCellItem {
    var itemType: ItemType = .eventNoteItem
    var titleString: String
    
    init(title: String) {
        self.titleString = title
    }
    
}

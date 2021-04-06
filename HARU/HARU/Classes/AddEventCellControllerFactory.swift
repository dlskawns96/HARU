//
//  AddEventCellControllerFactory.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/18.
//

import Foundation

protocol AddEventCellItem {
    var itemType: ItemType {get}
}

enum ItemType {
    case textItem
    case calendarItem
    case textFieldItem
    case switchItem
    case calendarEditItem
    case eventNoteItem
    case alarmItem
}

class AddEventCellControllerFactory {
    func registerCells(on tableView: UITableView) {
        TextFieldCellController.registerCell(on: tableView)
        CalendarCellController.registerCell(on: tableView)
        TextCellController.registerCell(on: tableView)
        SwitchCellController.registerCell(on: tableView)
        CalendarEditCellController.registerCell(on: tableView)
        EventNoteCellController.registerCell(on: tableView)
    }
    
    func cellControllers(with items: [[AddEventCellItem]]) -> [[AddEventCellController]] {
        var controllers = [[AddEventCellController]]()
        for section in 0..<items.count {
            controllers.append([])
            for row in 0..<items[section].count {
                switch items[section][row].itemType {
                case .calendarItem:
                    controllers[section].append(CalendarCellController(item: items[section][row]))
                case .switchItem:
                    controllers[section].append(SwitchCellController(item: items[section][row]))
                case .textFieldItem:
                    controllers[section].append(TextFieldCellController(item: items[section][row]))
                case .textItem:
                    controllers[section].append(TextCellController(item: items[section][row]))
                case .calendarEditItem:
                    controllers[section].append(CalendarEditCellController(item: items[section][row]))
                case .eventNoteItem:
                    controllers[section].append(EventNoteCellController(item: items[section][row]))
                case .alarmItem:
                    controllers[section].append(AlarmCellController(item: items[section][row]))
                }
            }
        }
        
        return controllers
    }
}

protocol AddEventCellController {
    static func registerCell(on tableView: UITableView)
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell
    func didSelectCell()
}

//
//  HARUWidget.swift
//  HARUWidget
//
//  Created by Lee Nam Jun on 2021/11/29.
//

import WidgetKit
import SwiftUI
import EventKit

// 특정시간마다 메소드 호출해서 새로운 timeline 요구
struct Provider: TimelineProvider {
    let calendarLoader = CalendarLoader()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(context: context.family, date: Date(), events: [])
    }
    
    // 처음 위젯을 추가할 때
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        var entry = SimpleEntry(context: context.family, date: Date(), events: [])
        if context.family == .systemSmall {
            let nextEvent = calendarLoader.firstEventOfFuture30Days()
            if nextEvent != nil {
                entry = SimpleEntry(context: context.family, date: Date(), events: [[nextEvent!]])
            }
        } else {
            let events = calendarLoader.loadEvents(ofDay: Date(), for: 4)
            entry = SimpleEntry(context: context.family, date: Date(), events: events)
        }
        completion(entry)
        
    }
    
    // 위젯을 추가한 이후
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entry = SimpleEntry(context: context.family , date: Date(), events: [])
        let currentDate = Date()
        
        // 5분 마다 새로고침
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        if context.family == .systemSmall {
            let nextEvent = calendarLoader.firstEventOfFuture30Days()
            if nextEvent != nil {
                let nextEvent = calendarLoader.firstEventOfFuture30Days()
                entry = SimpleEntry(context: context.family, date: Date(), events: [[nextEvent!]])
            }
        } else {
            let events = calendarLoader.loadEvents(ofDay: Date(), for: 4)
            entry = SimpleEntry(context: context.family, date: Date(), events: events)
        }
        
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let context: WidgetFamily
    let date: Date
    let events: [[EKEvent]]
}

struct HARUWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(uiColor: .mainColor).ignoresSafeArea()
            HStack {
                VStack {
                    Image(uiImage: .mainIcon)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 10)
            
            VStack {
                if entry.context == .systemSmall {
                    Text("다음 일정").bold().font(.system(size: 20)).padding(.bottom, 20).foregroundColor(.white)
                    let next = entry.events.first?.first
                    if next != nil {
                        Text(next!.startDate.toString(dateFormat: "MM월 dd일 E"))
                            .bold().font(.system(size: 15))
                            .padding(.bottom, 5)
                            .foregroundColor(.white)
                        Text(next!.title!)
                            .foregroundColor(.white)
                    } else {
                        Text("30일간 일정 없음").bold()
                            .foregroundColor(.white)
                    }
                } else {
                    ZStack {
                        Text("5일간 일정").bold().font(.system(size: 20)).padding(.bottom, 50).foregroundColor(.white)
                        let today = Date()
                        GeometryReader { metrics in
                            HStack {
                                VStack {
                                    HStack {
                                        ForEach(0..<entry.events.count) { idx in
                                            Text(Calendar.current.date(byAdding: .day, value: idx, to: today)!.toString(dateFormat: "MM/dd E"))
                                                .bold().font(.caption2)
                                                .padding(.bottom, 5)
                                                .frame(width: metrics.size.width * 0.175)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(alignment: .center)
                                    
                                    HStack {
                                        ForEach(0..<entry.events.count) { idx in
                                            VStack {
                                                ForEach(entry.events[idx]) { event in
                                                    Text(event.title!)
                                                        .font(.caption2).lineLimit(1)
                                                        .foregroundColor(.white)
                                                    
                                                }
                                            }
                                            .frame(width: metrics.size.width * 0.175)
                                        }
                                    }.frame(alignment: .center)
                                }
                            }
                            .padding(.top, metrics.size.height * 0.5)
                            .frame(width: metrics.size.width, alignment: .center)
                        }
                    }
                }
            }
            .frame(alignment: .top)
            .ignoresSafeArea()
        }
    }
}

@main
struct HARUWidget: Widget {
    let kind: String = "HARUWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HARUWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("HARU")
        .description("HARU 위젯으로 일정을 확인하세요")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//struct HARUWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        HARUWidgetEntryView(entry: SimpleEntry(context: .systemSmall,date: Date(), events: []))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

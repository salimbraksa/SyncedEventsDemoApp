//
//  EventViewModel.swift
//  EventsApp
//
//  Created by Salim Braksa on 4/26/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import Foundation
import Signals

class EventViewModel {
    
    // MARK: Properties
    
    let event: Event
    let remainingTime = Signal<RemainingTime>(retainLastData: true)
    
    // MARK: Internal
    
    private var timer: Timer?
    
    // MARK: - Lifecycle
    
    init(_ event: Event) {
        self.event = event
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            self?.handle(timer: timer)
        }
        self.timer = timer
        RunLoop.main.add(timer, forMode: .commonModes)
        handle(timer: timer)
    }
    
    deinit {
        timer?.invalidate()
        remainingTime.cancelAllSubscriptions()
    }
    
    // MARK: - Internal
    
    private func handle(timer: Timer) {
        let start = event.start
        let end = event.end
        
        // The distance between start & end ( should be strictly positive )
        let distance = end.timeIntervalSince(start)
        guard distance > 0 else { return }
        
        // The distance between now and start ( also represents the elapsed time )
        let now = Date()
        let remainingTime = max(0, min(distance, end.timeIntervalSince(now)))
        
        // Notify observers
        self.remainingTime.fire(remainingTime)
        
        // Stop timer when it's done
        if remainingTime == 0 {
            timer.invalidate()
        }
        
    }
    
    // MARK: - Tools
    
    func dateComponentsFormatter(fromRemainingTime value: TimeInterval) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        if value < 60 {
            formatter.allowedUnits = [.second]
        } else {
            formatter.allowedUnits = [.hour, .minute]
        }
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    // MARK: - Types
    
    typealias RemainingTime = TimeInterval
    
}

//
//  EventTableViewCell.swift
//  EventsApp
//
//  Created by Salim Braksa on 4/26/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var viewModel: EventViewModel! {
        didSet {
            self.configure(new: viewModel, old: oldValue)
        }
    }
    
    // MARK: - Config
    
    private func configure(new: EventViewModel, old: EventViewModel?) {
        
        old?.remainingTime.cancelSubscription(for: self)
        new.remainingTime.subscribePast(with: self) { [weak self] remainingTime in
            self?.configure(remainingTime: remainingTime)
        }
        
        textLabel?.text = viewModel.event.title
        
    }
    
    private func configure(remainingTime: TimeInterval) {
        let formatter = viewModel.dateComponentsFormatter(fromRemainingTime: remainingTime)
        guard let time = formatter.string(from: remainingTime) else { return }
        let text = "\(time) left for this event to end"
        detailTextLabel?.text = text
    }
    
}


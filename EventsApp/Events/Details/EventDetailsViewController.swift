//
//  EventDetailsViewController.swift
//  EventsApp
//
//  Created by Salim Braksa on 4/26/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: EventViewModel!
    
    // MARK: Outlets
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: viewModel)
    }
    
    // MARK: - Configuration
    
    private func configure(with viewModel: EventViewModel) {
        viewModel.remainingTime.subscribePast(with: self) { [weak self] value in
            guard let `self` = self else { return }
            let formatter = viewModel.dateComponentsFormatter(fromRemainingTime: value)
            if value > 0 {
                self.remainingTimeLabel.text = formatter.string(from: value)
            } else {
                self.remainingTimeLabel.text = "Event has ended"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: { [unowned self] in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
}

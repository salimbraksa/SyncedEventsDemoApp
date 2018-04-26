//
//  EventsViewController.swift
//  EventsApp
//
//  Created by Salim Braksa on 4/26/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    private var data = [EventViewModel]()
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add fake data just to experiment
        for i in 1..<100 {
            let event = Event()
            event.title = "Event #\(i)"
            event.start = zeroSecondsDate(from: Date())
            let random = TimeInterval(arc4random_uniform(10)) + 1
            event.end = event.start + 60 * random // +random hours
            let viewModel = EventViewModel(event)
            viewModel.remainingTime.subscribePast(with: self) { (remainingTime) in
                guard remainingTime == 0 else { return }
                self.delete(viewModel: viewModel)
            }
            data.append(viewModel)
        }
        
    }
    
    // MARK: -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "showEventDetails":
            let destination = segue.destination as! EventDetailsViewController
            let viewModel = sender as! EventViewModel
            destination.viewModel = viewModel
            destination.title = viewModel.event.title
        default: break
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell
        let viewModel = data[indexPath.row]
        cell.viewModel = viewModel
        return cell
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event = data[indexPath.row]
        performSegue(withIdentifier: "showEventDetails", sender: event)
    }
    
    // MARK: - Helpers
    
    private func delete(viewModel: EventViewModel) {
        guard let index = self.data.index(where: { $0 === viewModel }) else { return }
        self.data.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func zeroSecondsDate(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                 from: date)
        return calendar.date(from: components)!
    }
    
}

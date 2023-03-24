//
//  ViewController.swift
//  CountingClimbs
//
//  Created by Sophia Chiang on 3/29/23.
//

import UIKit

class ClimbListViewController: UIViewController {
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func sortClimbs(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.climbs.sort { $0.name < $1.name }
        case 1:
            self.climbs.sort { $0.name > $1.name }
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    var climbs: [Climb] = []
    var climbService: ClimbService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.climbService = ClimbService()
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.title = "Climbs"
        
    }
    

    
//    enum CustomError: Error {
//        case empty
//    }
//    extension CustomError: CustomStringConvertible {
//        public var description: String {
//            switch self {
//            case .empty:
//                return "The API is empty."
//            }
//        }
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        
        guard let confirmedService = self.climbService else { return }
        
        confirmedService.getClimbs(completion: { climbs, error in
            guard let climbs = climbs, error == nil else {
                let climbError = error as! ClimbCallingError
                switch (climbError) {
                case .emptyAPI:
                    print ("empty API") //#7. Let app user know that the list is empty
                case .problemDecodingData:
                    print ("problemDecodingData")
                case .problemGeneratingURL:
                    print ("problemGeneratingURL")
                case .problemGettingDataFromAPI:
                    print ("problemGettingDataFromAPI")
                
                }
                // here's where I can use errors to change UI
                return
            }
            self.climbs = climbs
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? DetailViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow,
            let confirmedCell = self.tableView.cellForRow(at: selectedIndexPath) as? ClimbCellTableViewCell else { return }
                    
        let confirmedClimb = confirmedCell.climb
        destination.climb = confirmedClimb
    }
    
//    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            shows.showArray.sort(by : {$0.show.name < $1.show.name})
//        case 1:
//            shows.showArray.sort(by: {$0.show.rating?.average ?? 0.0 > $1 show.rating?.average ?? 0.0})
//        default:
//            print("ERROR: This should never happen.")
//        }
//        tableView.reloadData()
//    }
    
}

extension ClimbListViewController: UITableViewDataSource {
    //MARK: DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "climbCell") as! ClimbCellTableViewCell
        
        let currentClimb = self.climbs[indexPath.row]
        
        cell.climb = currentClimb
        
        if currentClimb.isFavorite {
            cell.backgroundColor = .systemPink
            
            //Color(red: 250, green: 218, blue: 221)
        }
        
        if currentClimb.isFinished {
            cell.accessoryType = .checkmark
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.climbs.count
    }
    
}
    
extension ClimbListViewController: UITableViewDelegate {
    //MARK: Delegate
    
    
//Checkmark from Chelsea videos
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if
//            let cell = self.tableView.cellForRow(at: indexPath) as? ClimbCellTableViewCell,
//            let confirmedFinishedClimb = cell.climb
//        {
//            confirmedFinishedClimb.finishedClimb = true
//            cell.accessoryType = confirmedFinishedClimb.finishedClimb ? .checkmark : .none
//        }
//    }
//
    
//Swipe functionality
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {action, indexPath in self.climbs.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let cell = climbs[indexPath.row]
        
        let favoriteActionTitle = cell.isFavorite ? "Unfavorite" : "Favorite"
        let favoriteAction = UITableViewRowAction(style: .normal, title: favoriteActionTitle) {action, indexPath in
            self.climbs[indexPath.row].isFavorite.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        favoriteAction.backgroundColor = .systemGreen
        
        let finishedActionTitle = cell.isFinished ? "In progress" : "Finished"
        let finishedAction = UITableViewRowAction(style: .normal, title: finishedActionTitle) {action, indexPath in
            self.climbs[indexPath.row].isFinished.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        finishedAction.backgroundColor = .systemBlue

        return [deleteAction, favoriteAction, finishedAction]
    }
}





import UIKit

class ParcelTableViewController: UITableViewController {
    
    var parcels = [Parcel]()
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parcels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParcelCell", for: indexPath) as! ParcelTableViewCell
        
        let parcel = parcels[indexPath.row]
        
        cell.update(with: parcel)
        cell.showsReorderControl = true
        
        return cell
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            parcels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        Parcel.saveToFile(parcels: parcels)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedParcel = parcels.remove(at: fromIndexPath.row)
        parcels.insert(movedParcel, at: to.row)
        tableView.reloadData()
        Parcel.saveToFile(parcels: parcels)
    }
    
    @objc func refreshControlActivated(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedParcels = Parcel.loadFromFile() {
            parcels = savedParcels
        } else {
            parcels = Parcel.loadSampleParcel()
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshControlActivated(sender:)), for: .valueChanged)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToPacelTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddEditParcelTableViewController
        
        if let parcel = sourceViewController.parcel {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                parcels[selectedIndexPath.row] = parcel
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: parcels.count, section: 0)
                parcels.append(parcel)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        Parcel.saveToFile(parcels: parcels)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditParcel" {
            let indexPath = tableView.indexPathForSelectedRow!
            let parcel = parcels[indexPath.row]
            let addEditParcelTableViewController = segue.destination as! AddEditParcelTableViewController
            addEditParcelTableViewController.parcel = parcel
        }
    }
}

@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


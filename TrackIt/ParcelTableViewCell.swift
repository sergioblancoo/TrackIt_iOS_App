
import UIKit

class ParcelTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with parcel: Parcel) {
        recipientLabel.text = parcel.recipientName
        deliveryAddressLabel.text = parcel.deliveryAddress
        statusLabel.text = parcel.status
        if parcel.status == "Dispatched" {
            statusLabel.textColor = UIColor.green
        } else if parcel.status == "Delivered" {
            statusLabel.textColor = UIColor.gray
        } else {
            statusLabel.textColor = UIColor.orange
        }
    }
}


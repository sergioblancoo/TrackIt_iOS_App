
import Foundation

class Parcel: NSObject, NSCoding {
    var status: String
    var statusLastUpdatedDate: String
    var trackingNumber: String
    var recipientName: String
    var deliveryAddress: String
    var deliveredDate: String
    var notes: String
    
    struct PropertyKey {
        static let status = "status"
        static let statusLastUpdatedDate = "statusLastUpdatedDate"
        static let trackingNumber = "trackingNumber"
        static let recipientName = "recipientName"
        static let deliveryAddress = "deliveryAddress"
        static let deliveredDate = "deliveredDate"
        static let notes = "notes"
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("parcels")
    
    init(status: String, statusLastUpdatedDate: String, trackingNumber: String, recipientName: String, deliveryAddress: String, deliveredDate: String, notes: String) {
        self.status = status
        self.statusLastUpdatedDate = statusLastUpdatedDate
        self.trackingNumber = trackingNumber
        self.recipientName = recipientName
        self.deliveryAddress = deliveryAddress
        self.deliveredDate = deliveredDate
        self.notes = notes
    }
    
    static func loadFromFile() -> [Parcel]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Parcel.ArchiveURL.path) as? [Parcel]
    }
    
    static func loadSampleParcel() -> [Parcel] {
        return [Parcel(status: "To Send", statusLastUpdatedDate: "09.05.2018 23:50", trackingNumber: "123456789", recipientName: "John Smith", deliveryAddress: "124 La Trobe St, Melbourne VIC 3000", deliveredDate: "11.05.2018 11:59", notes: "This is an example of a Parcel.")]
    }
    
    static func saveToFile(parcels: [Parcel]) {
        NSKeyedArchiver.archiveRootObject(parcels, toFile: Parcel.ArchiveURL.path)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let status = aDecoder.decodeObject(forKey: PropertyKey.status) as? String,
            let statusLastUpdatedDate = aDecoder.decodeObject(forKey: PropertyKey.statusLastUpdatedDate) as? String,
            let trackingNumber = aDecoder.decodeObject(forKey: PropertyKey.trackingNumber) as? String,
            let recipientName = aDecoder.decodeObject(forKey: PropertyKey.recipientName) as? String,
            let deliveryAddress = aDecoder.decodeObject(forKey: PropertyKey.deliveryAddress) as? String,
            let deliveredDate = aDecoder.decodeObject(forKey: PropertyKey.deliveredDate) as? String,
            let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
            else {
                return nil
        }
        
        self.init(status: status, statusLastUpdatedDate: statusLastUpdatedDate, trackingNumber: trackingNumber, recipientName: recipientName, deliveryAddress: deliveryAddress, deliveredDate: deliveredDate, notes: notes)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(status, forKey: PropertyKey.status)
        aCoder.encode(statusLastUpdatedDate, forKey: PropertyKey.statusLastUpdatedDate)
        aCoder.encode(trackingNumber, forKey: PropertyKey.trackingNumber)
        aCoder.encode(recipientName, forKey: PropertyKey.recipientName)
        aCoder.encode(deliveryAddress, forKey: PropertyKey.deliveryAddress)
        aCoder.encode(deliveredDate, forKey: PropertyKey.deliveredDate)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
}

//To Implement to avoid Hardcoding in AddEditParcelTableViewController
//enum StatusType: String {
//    case ToSend = "To Send", Dispatched = "Dispatched", Delivered = "Delivered"
//
//    static let statusTypes = [ToSend, Dispatched, Delivered]
//}



import UIKit

class AddEditParcelTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var recipientNameTextField: UITextField!
    @IBOutlet weak var deliveryAddressTextField: UITextField!
    @IBOutlet weak var lastUpdatedDateTimeLabel: UILabel!
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var deliveredDateTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    
    @IBOutlet weak var toSendButton: UIButton!
    @IBOutlet weak var dispatchedButton: UIButton!
    @IBOutlet weak var deliveredButton: UIButton!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var parcelStatus: String = ""
    
    @IBAction func statusSelected(_ sender: UIButton) {
        switch sender {
        case toSendButton:
            parcelStatus = "To Send"
            toSendButton.isSelected = true
            dispatchedButton.isSelected = false
            deliveredButton.isSelected = false
        case dispatchedButton:
            parcelStatus = "Dispatched"
            dispatchedButton.isSelected = true
            toSendButton.isSelected = false
            deliveredButton.isSelected = false
        case deliveredButton:
            parcelStatus = "Delivered"
            deliveredButton.isSelected = true
            toSendButton.isSelected = false
            dispatchedButton.isSelected = false
        default:
            return
        }
    }
    
    @IBAction func deliveredDateTextField(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddEditParcelTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        deliveredDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    var parcel: Parcel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parcel = parcel {
            if parcel.status == "Dispatched" {
                dispatchedButton.isSelected = true
            } else if parcel.status == "Delivered" {
                deliveredButton.isSelected = true
            } else {
                toSendButton.isSelected = true
            }
            
            lastUpdatedDateTimeLabel.text = parcel.statusLastUpdatedDate
            trackingNumberTextField.text = parcel.trackingNumber
            recipientNameTextField.text = parcel.recipientName
            deliveryAddressTextField.text = parcel.deliveryAddress
            deliveredDateTextField.text = parcel.deliveredDate
            notesTextField.text = parcel.notes
        }
        else {
            toSendButton.isSelected = true
            parcel?.status = "To Send"
            parcelStatus = "To Send"
        }
        
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        if dispatchedButton.isSelected {
            parcelStatus = "Dispatched"
        } else if deliveredButton.isSelected {
            parcelStatus = "Delivered"
        } else {
            parcelStatus = "To Send"
        }
        let status = parcelStatus
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let statusLastupdatedDate = formatter.string(from: date)
        
        let trackingNumber = trackingNumberTextField.text ?? ""
        let recipientName = recipientNameTextField.text ?? ""
        let deliveryAddress = deliveryAddressTextField.text ?? ""
        let deliveredDate = deliveredDateTextField.text ?? ""
        let notes = notesTextField.text ?? ""
        parcel = Parcel(status: status, statusLastUpdatedDate: statusLastupdatedDate, trackingNumber: trackingNumber, recipientName: recipientName, deliveryAddress: deliveryAddress, deliveredDate: deliveredDate, notes: notes)
    }
    
    func updateSaveButtonState() {
        let recipientNameText = recipientNameTextField.text ?? ""
        
        saveButton.isEnabled = !recipientNameText.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        guard let parcel = parcel else { return }
            let activityController = UIActivityViewController(activityItems: [parcel.status, parcel.recipientName, parcel.deliveryAddress, parcel.trackingNumber, parcel.deliveredDate], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = sender

        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in imagePicker.sourceType = .camera
//                self.present(imagePicker, animated: true, completion: nil)
//            })
//            alertController.addAction(cameraAction)
//        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var parcelPhoto: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            parcelPhoto.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}

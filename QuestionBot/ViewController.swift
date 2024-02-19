import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var questionField: UITextField!
    
    let questionAnswerer = MyQuestionAnswerer()

    override func viewDidLoad() {
        super.viewDidLoad()
        questionField.becomeFirstResponder()
        responseLabel.numberOfLines = Int.max
    }
    func respondToQuestion(_ question: String) {
        responseLabel.text = "Waiting..."
        let _ = questionAnswerer.responseTo(question: question) { [self] answer in
            DispatchQueue.main.async { [self] in
                responseLabel.text = answer
                responseLabel.numberOfLines = 0
                responseLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                responseLabel.font = responseLabel.font
                responseLabel.sizeToFit()
            }
        }
        questionField.placeholder = "Ask another question..."
        questionField.text = nil
        askButton.isEnabled = false
    }

    @IBAction func askButtonTapped(_ sender: AnyObject) {
        guard questionField.text != nil else {
            return
        }
        questionField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        respondToQuestion(text)
    }
    
    @IBAction func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            askButton.isEnabled = false
            return
        }
        
        askButton.isEnabled = !text.isEmpty
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
       let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.font = font
       label.text = text

       label.sizeToFit()
       return label.frame.height
   }
}

//
//  ViewController.swift
//  Albertsons
//
//  Created by Gopi Krishna Yenuganti on 10/17/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var inputTextField: UITextField!
  
  @IBOutlet weak var tableview: UITableView!
  
  var viewModel = ResponseViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    inputTextField.delegate = self
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
    let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if trimmedString.count > 1 {
      viewModel.getResponse(value: trimmedString) {
        DispatchQueue.main.async() {
          self.tableview.reloadData()
        }
      } onFailure: {
        print("error getting textField.text")
      }
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.cellsToDisplay()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayCell", for: indexPath)
    if let displayCell = cell as? TableViewCell, let model = viewModel.modelForCell(index: indexPath.row) {
      displayCell.configureCell(model: model)
    }
    return cell
  }
  
}
                            


class TableViewCell: UITableViewCell {
  
  @IBOutlet weak var lfLabel: UILabel!
  @IBOutlet weak var freqLabel: UILabel!
  @IBOutlet weak var sinceLabel: UILabel!

  func configureCell(model: LF?) {
    guard let data = model else { return }
    lfLabel.text = data.lf
    freqLabel.text = "\(data.freq)"
    sinceLabel.text = "\(data.since)"
  }
  
}

/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit

class FetchViewController: UIViewController {
  
  @IBOutlet var updateLabel: UILabel!
  
  private var time: Date?
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .long
    return formatter
  }()
  
  func fetch(_ completion: () -> Void) {
    time = Date()
    completion()
  }
  
  func updateUI() {
    guard updateLabel != nil  else {
      return
    }
    
    if let time = time {
      updateLabel.text = dateFormatter.string(from: time)
    } else {
      updateLabel.text = "Not yet updated"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  @IBAction func didTapUpdate(_ sender: UIButton) {
    fetch { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.updateUI()
    }
  }
}

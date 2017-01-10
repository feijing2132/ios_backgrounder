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
import AVFoundation

class AudioViewController: UIViewController {
  
  @IBOutlet var songLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!
  lazy var player: AVQueuePlayer = self.makePlayer()
  
  private lazy var songs: [AVPlayerItem] = {
    let songNames = ["FeelinGood", "IronBacon", "WhatYouWant"]
    return songNames.map {
      let url = Bundle.main.url(forResource: $0, withExtension: "mp3")!
      return AVPlayerItem(url: url)
    }
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      try AVAudioSession.sharedInstance().setCategory(
            AVAudioSessionCategoryPlayAndRecord,
            with: .defaultToSpeaker)
    } catch {
      print("Failed to set audio session category.  Error: \(error)")
    }
    
    player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 100), queue: DispatchQueue.main) {
      [weak self] time in
      guard let strongSelf = self else { return }
      let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
      
      if UIApplication.shared.applicationState == .active {
        strongSelf.timeLabel.text = timeString
      } else {
        print("Background: \(timeString)")
      }
    }
  }
  
  private func makePlayer() -> AVQueuePlayer {
    let player = AVQueuePlayer(items: songs)
    player.actionAtItemEnd = .advance
    player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial] , context: nil)
    return player
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "currentItem", let player = object as? AVPlayer,
      let currentItem = player.currentItem?.asset as? AVURLAsset {
      songLabel.text = currentItem.url.lastPathComponent
    }
  }
  
  @IBAction func playPauseAction(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    if sender.isSelected {
      player.play()
    } else {
      player.pause()
    }
  }
}


//
//  ViewController.swift
//  Example
//
//  Created by Rui Peres on 05/12/2015.
//  Copyright © 2015 MailOnline. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var panoramaImageView: UIImageView!
    @IBOutlet weak var giraffeImageView: UIImageView!

    class SomeImageProvider: ImageProvider {

        let images = [
            UIImage(named: "0"),
            UIImage(named: "1"),
            UIImage(named: "2"),
            UIImage(named: "3"),
            UIImage(named: "4"),
            UIImage(named: "5"),
            UIImage(named: "6"),
            UIImage(named: "7")]

        var imageCount: Int {
            return images.count
        }

        func provideImage(completion: UIImage? -> Void) {
            completion(UIImage(named: "image_big"))
        }

        func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
            completion(images[index])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showSingleImageViewer(sender: UIButton) {
        
        let imageProvider = SomeImageProvider()
        let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
        let configuration = ImageViewerConfiguration(imageSize: CGSize(width: 10, height: 10), closeButtonAssets: buttonAssets)
        
        let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: sender)
        self.presentImageViewer(imageViewer)
    }
    
    @IBAction func showGalleryImageViewer(displacedView: UIView) {
        
        let imageProvider = SomeImageProvider()
        let frame = CGRect(x: 0, y: 0, width: 200, height: 24)
        let headerView = CounterView(frame: frame, currentIndex: displacedView.tag, count: imageProvider.imageCount)
        let footerView = CounterView(frame: frame, currentIndex: displacedView.tag, count: imageProvider.imageCount)

        let galleryViewController = GalleryViewController(imageProvider: imageProvider, displacedView: displacedView, imageCount: imageProvider.imageCount, startIndex: displacedView.tag)

        galleryViewController.headerView = headerView
        galleryViewController.footerView = footerView
        
        galleryViewController.launchedCompletion = { print("LAUNCHED") }
        galleryViewController.closedCompletion = { print("CLOSED") }
        galleryViewController.swipedToDismissCompletion = { print("SWIPE-DISMISSED") }

        galleryViewController.landedPageAtIndexCompletion = { index in
            
            print("LANDED AT INDEX: \(index)")
            
            headerView.currentIndex = index
            footerView.currentIndex = index
        }
        
        self.presentImageGallery(galleryViewController)
    }
}

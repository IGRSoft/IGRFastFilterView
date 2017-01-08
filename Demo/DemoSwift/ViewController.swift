//
//  ViewController.swift
//  DemoSwift
//
//  Created by Vitalii Parovishnyk on 1/8/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit
import IGRFastFilterView

class ViewController: UIViewController {
    
    @IBOutlet weak fileprivate var instaFiltersView: IGRFastFilterView?
    
    static let kImageNotification = NSNotification.Name(rawValue: "WorkImageNotification")
    let kDemoImage = UIImage.init(named: "demo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTheme()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(setupWorkImage(_:)),
                                       name: ViewController.kImageNotification,
                                       object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.once(token: "com.igrsoft.fastfilter.demo") {
            self.setupDemoView()
        }
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self,
                                          name: ViewController.kImageNotification,
                                          object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.instaFiltersView?.layoutSubviews()
        }, completion: nil)
    }
    
    fileprivate func setupTheme () {
        IGRFastFilterView.appearance().backgroundColor = UIColor(white:0.7, alpha:1.0)
        IGRFiltersbarCollectionView.appearance().backgroundColor = UIColor(white:0.9, alpha:1.0)
    }
    
    fileprivate func setupDemoView() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: ViewController.kImageNotification, object: kDemoImage)
    }
    
    func setupWorkImage(_ notification: Notification) {
        assert(notification.object is UIImage, "Image only allowed!");
        instaFiltersView?.setImage(notification.object as! UIImage)
    }
    
    func prepareImage() -> UIImage {
        return self.instaFiltersView!.processedImage!;
    }
    
    @IBAction func onTouchGetImageButton(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController.init(title: NSLocalizedString("Select image", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.popoverPresentationController?.barButtonItem = sender;
        
        func completeAlert(type: UIImagePickerControllerSourceType) {
            let pickerView = UIImagePickerController.init()
            pickerView.delegate = self
            pickerView.sourceType = type
            self.present(pickerView, animated: true, completion: nil)
        }
        
        let style = UIAlertActionStyle.default
        var action = UIAlertAction.init(title: NSLocalizedString("From Library", comment: ""),
                                        style: style) { (UIAlertAction) in
                                            completeAlert(type: UIImagePickerControllerSourceType.photoLibrary)
        }
        
        alert.addAction(action)
        
        action = UIAlertAction.init(title: NSLocalizedString("From Camera", comment: ""),
                                    style: style) { (UIAlertAction) in
                                        completeAlert(type: UIImagePickerControllerSourceType.camera)
        }
        
        alert.addAction(action)
        
        action = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""),
                                    style: style)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onTouchShareButton(_ sender: UIBarButtonItem) {
        
        let image = prepareImage()
        
        let avc = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
        
        avc.popoverPresentationController?.barButtonItem = sender;
        avc.popoverPresentationController?.permittedArrowDirections = .up;
        
        self.present(avc, animated: true, completion: nil)
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: ViewController.kImageNotification, object: image)
        
        picker.dismiss(animated: true, completion: nil)
    }
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}


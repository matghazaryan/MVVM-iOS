//
//  SettingsVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/15/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsVC: UITableViewController {

    @IBOutlet private weak var avatar: UIImageView!
    let viewModel = SettingViewModel()
    lazy var imagePicker: UIImagePickerController =  {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigation()
        bindViews()
    }
    
    private func setupNavigation() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
        saveButton.rx.tap.bind{
            print("ipload...")
            }.disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func bindViews() {
        let tapGesture = avatar.gestureRecognizers?.first
        tapGesture?.rx.event.subscribe(onNext: {[weak self] _ in
            guard let weakSelf = self else { return }
            self?.present(weakSelf.imagePicker, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        
        viewModel.imageData.map({ unwrapedData -> UIImage? in
            guard let data = unwrapedData,
                let image = UIImage(data: data) else {
                    return #imageLiteral(resourceName: "avatar")
            }
            return image
        })
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
    }

}

extension SettingsVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = (info[.originalImage] as? UIImage)?.pngData()
        viewModel.setImageData(imageData)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


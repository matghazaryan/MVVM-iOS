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
        viewModel.bindToUpload(saveButton.rx.tap)
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func bindViews() {
        let tapGesture = avatar.gestureRecognizers?.first
        tapGesture?.rx.event.subscribe(onNext: {[weak self] _ in
            guard let weakSelf = self else { return }
            self?.present(weakSelf.imagePicker, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        viewModel.successUpload.subscribe(onNext: {
            if $0 {
                self.navigationController?.popViewController(animated: true)
            }
        })
        .disposed(by: disposeBag)
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
        let url = info[.referenceURL] as? URL
        DataRepository.getInstance().prefSetAvatarURL(url)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


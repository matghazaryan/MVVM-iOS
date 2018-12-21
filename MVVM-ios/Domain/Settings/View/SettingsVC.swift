//
//  SettingsVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/15/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

class SettingsVC: UITableViewController {
    
    override var viewmodelClass: AnyClass {
        return SettingViewModel.self
    }
    
    @IBOutlet private weak var avatar: UIImageView!
    
    lazy var imagePicker: UIImagePickerController =  {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    override var updateViewOnLanguageChange: Bool {
        return true
    }
    
    override func viewDidLoad() {
        setupNavigation()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !getViewModel(as: SettingViewModel.self).enableSaveButton.value {
            guard let url = DataRepository.preference().getAvatarURL() else {
                avatar.image = #imageLiteral(resourceName: "avatar")
                return
            }
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            guard let result = asset.firstObject else {
                avatar.image = #imageLiteral(resourceName: "avatar")
                return
            }
            let imageManager = PHImageManager.default()
            imageManager.requestImageData(for: result, options: nil) { data, string, orientation, dict in
                guard let data = data else {
                    return
                }
                let image = UIImage(data: data)
                self.avatar.image = image
            }
        }
    }
    
    private func setupNavigation() {
        let saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    internal override func bindViews() {
        let tapGesture = avatar.gestureRecognizers?.first
        tapGesture?.rx.event.subscribe(onNext: {[weak self] _ in
            guard let weakSelf = self else { return }
            self?.present(weakSelf.imagePicker, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        getViewModel(as: SettingViewModel.self).bindToUpload(self.navigationItem.rightBarButtonItem!.rx.tap)
        
        getViewModel(as: SettingViewModel.self).enableSaveButton
            .bind(to: self.navigationItem.rightBarButtonItem!.rx.isEnabled)
            .disposed(by: disposeBag)
        
        getViewModel(as: SettingViewModel.self).successUpload.subscribe(onNext: {
            if $0 {
                self.navigationController?.popViewController(animated: true)
            }
        })
            .disposed(by: disposeBag)
        getViewModel(as: SettingViewModel.self).imageData.map({ unwrapedData -> UIImage? in
            guard let data = unwrapedData,
                let image = UIImage(data: data) else {
                    return #imageLiteral(resourceName: "avatar")
            }
            return image
        })
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        
        (viewModel.getAction(Action.openErrorDialog) as Observable<Error>)
            .subscribe(onNext: { error in
                UIAlertController.showError(error)
            })
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(SelectLanguageVC(), animated: true)
    }

}

extension SettingsVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = (info[.originalImage] as? UIImage)?.pngData()
        getViewModel(as: SettingViewModel.self).setImageData(imageData)
        getViewModel(as: SettingViewModel.self).imagePath = info[.referenceURL] as? URL
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


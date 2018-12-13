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

class SettingsVC: UITableViewController, BaseViewController {
    
    var viewModel: SettingViewModel = SettingViewModel()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet private weak var avatar: UIImageView!
    
    lazy var imagePicker: UIImagePickerController =  {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        setupNavigation()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let url = DataRepository.getInstance().prefGetAvatarURL() else {
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
//        viewModel.bindToUpload(self.navigationItem.rightBarButtonItem!.rx.tap)
        self.navigationItem.rightBarButtonItem!.rx.tap.asObservable()
            .withLatestFrom(viewModel.imageData)
            .flatMap { data -> Observable<Bool> in
                guard let data = data else {
                    return Observable.just(false)
                }
                return DataRepository.getInstance().apiUploadImage(data)
                    .map({ response -> Bool in
                        return response.completed
                    })
            }
            .retry()
            .share(replay: 1)
            .subscribe(onNext: { complete in
                if complete {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    UIAlertController.showAsToastWith(message: "incomplete")
                }
            }, onError: { error in
                UIAlertController.showError(error)
            })
        .disposed(by: disposeBag)
    }
    
    override func onLanguageChange(_ node: Notification) {
        self.view = nil
        self.viewWillAppear(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(SelectLanguageVC(), animated: true)
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


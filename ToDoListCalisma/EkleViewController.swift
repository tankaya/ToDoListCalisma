//
//  EkleViewController.swift
//  ToDoListCalisma
//
//  Created by Taner Kaya on 12.04.2023.
//

import UIKit

class EkleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var eklemeAlani: UITextField!
    
    var guncelle: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eklemeAlani.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Kaydet", style: .done, target: self, action: #selector(yapilacaklariKaydet))

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        yapilacaklariKaydet()
        
        return true
    }
    
    
    @objc func  yapilacaklariKaydet(){
        
        guard let text = eklemeAlani.text, !text.isEmpty else {
            return
        }
        
        guard let count = UserDefaults().value(forKey: "sira") as? Int else{
            return
        }
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "sira")
        
        UserDefaults().set(text, forKey: "gorev_\(newCount)")
        
        //eger "guncelle"  diye bir fonksiyon varsa cagir.
        guncelle?()
        
        navigationController?.popViewController(animated: true)
    }
}

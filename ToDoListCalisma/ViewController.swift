//
//  ViewController.swift
//  ToDoListCalisma
//
//  Created by Taner Kaya on 12.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var yapilacaklar = [String]()
    
    var guncellemeAlani: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Yapilacaklar"
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Kurulum asamasi
        
        if !UserDefaults().bool(forKey: "kurulum"){
            UserDefaults().set(true, forKey: "kurulum")
            UserDefaults().set(0, forKey: "sira")
        }
        
        yapilacaklariGuncelle()
        
        
    }
    
    func yapilacaklariGuncelle(){
        
        yapilacaklar.removeAll()
        
        guard let count = UserDefaults().value(forKey: "sira") as? Int else{
            return
        }
        for i in 0..<count{
            
            //eger siradaki "yapilacak" nil degilse "yapilacaklar" listesine ekle
            if let task = UserDefaults().value(forKey: "gorev_\(i + 1)") as? String {
                yapilacaklar.append(task)
            }
        }
        
        tableView.reloadData()
    }

    @IBAction func ekleButonuTiklandi(){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ekle") as! EkleViewController
        
        vc.title = "Yeni Ekle"
        vc.guncelle = {
            
            DispatchQueue.main.async {
                self.yapilacaklariGuncelle()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Guncelle", message: "Gorevi guncelleyiniz.", preferredStyle: .alert)
        let update = UIAlertAction(title: "Tamam", style: .default) {action in
            let updatedNames = self.guncellemeAlani?.text
            self.yapilacaklar[indexPath.row] = updatedNames!
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
        
        let cancel = UIAlertAction(title: "Vazgec", style: .cancel)
        
        alert.addAction(update)
        alert.addAction(cancel)
        alert.addTextField { textField in
            self.guncellemeAlani = textField
            self.guncellemeAlani?.text = self.yapilacaklar[indexPath.row]
            self.guncellemeAlani?.placeholder = "Giriniz."
        }
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return yapilacaklar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = yapilacaklar[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        yapilacaklar.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        yapilacaklar.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    @IBAction func duzenleyeTiklandi(){
        if tableView.isEditing{
            tableView.isEditing = false
        }else{
            tableView.isEditing = true
        }
            
        
    }

}

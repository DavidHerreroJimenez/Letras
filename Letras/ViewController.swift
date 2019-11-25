// Package: Letras,
// File name: ViewController.swift,
// Created by David Herrero on 25/11/2019.

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var letters = ["A", "B", "C", "F", "G", "H", "I", "N"]
    
    var selectedLetter = ""
    
    @IBOutlet weak var myWordLabel: UILabel!
    @IBOutlet weak var resultMessageLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionViewCell
        
        cell.cellButton.setTitle(letters[indexPath.row], for: .normal)
        
        cell.cellButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.cellButton.isSelected = false
        
        return cell
    }
    

    
    @IBAction func cellButtonClick(_ sender: UIButton) {
        
        
        sender.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        sender.isSelected = true
        
        if let title = sender.titleLabel?.text{
            
            selectedLetter = title
                
        }else{
            selectedLetter = ""
        }
        
        
        if myWordLabel.text != nil {
            
            myWordLabel.text! += selectedLetter
            
        }else{
            myWordLabel.text = ""
            
            myWordLabel.text! += selectedLetter
            
        }
    }
    
    
    @IBAction func deleteCharClick(_ sender: UIButton) {
        
        if myWordLabel.text != nil && !myWordLabel.text!.isEmpty {
            
            myWordLabel.text?.removeLast()
            
        }
        
    }
    
    
    @IBAction func checkWordClick(_ sender: UIButton) {
        
        if let wordToCheck =  myWordLabel.text{
            if (!wordToCheck.isEmpty){
                
                if (wordToCheck.uppercased() == "caca".uppercased()){
                        
                        resultMessageLabel.text = "Palabra correcta!"
                    }else{
                        resultMessageLabel.text = "mmm...\nlo siento, no es una palabra...\n¡sigue probando!"
                    }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myWordLabel.text = selectedLetter
    }
    


}


// Package: Letras,
// File name: ViewController.swift,
// Created by David Herrero on 25/11/2019.

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var letters = ["A", "B", "C", "F", "G", "H", "I", "N"]
    
    
    var selectedLetter = ""
    var lastCharToRemove: String = ""
    var buttonsClicked: [UIButton] = []
    var wordResults: [String] = []
    
    var collectionView: UICollectionView?
    
    
    var timer: Timer?
    
    @IBOutlet weak var myWordLabel: UILabel!
    @IBOutlet weak var resultMessageLabel: UILabel!
    @IBOutlet weak var tableViewResults: UITableView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.collectionView = collectionView
        
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionViewCell
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
        cell.cellButton.setTitle(letters[indexPath.row], for: .normal)
        
        cell.cellButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.cellButton.isSelected = false
        
        cell.cellButton.layer.cornerRadius = 5
        cell.cellButton.layer.borderWidth = 1
        cell.cellButton.layer.borderColor = #colorLiteral(red: 0.7019607843, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        
        return cell
    }
    

    
    @IBAction func cellButtonClick(_ sender: UIButton) {

        sender.backgroundColor = #colorLiteral(red: 0.7019607843, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        sender.isSelected = true
        sender.isEnabled = false
        
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
        
        buttonsClicked.append(sender)
        
    }
    
    
    @IBAction func deleteCharClick(_ sender: UIButton) {
        
        if myWordLabel.text != nil && !myWordLabel.text!.isEmpty {
            
            lastCharToRemove = String(myWordLabel.text?.last ?? " ")
            
            /*
             collectionView.numberOfItems(inSection: 0)
             collectionView.cellForItem(at: indexPath as IndexPath)
            */
            if let button = buttonsClicked.last {
                
                button.isSelected = false
                button.isEnabled = true
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            }
            
            buttonsClicked.removeLast()

            myWordLabel.text?.removeLast()
        }
        
    }
    
    
    @IBAction func checkWordClick(_ sender: UIButton) {
        
        if let wordToCheck =  myWordLabel.text{
            if (!wordToCheck.isEmpty){
                
                if (wordToCheck.uppercased() == "china".uppercased()){
                        
                    
                    wordResults.append(wordToCheck)
                    
                    resultMessageLabel.text = "Palabra correcta!"
                    
                    resultMessageLabel.textColor = #colorLiteral(red: 0, green: 0.7141116858, blue: 0.285058111, alpha: 1)
                    
                    self.tableViewResults.reloadData()
                    
                    
                    resetAllButtons()
                    clearData()
                    
                }else{
                    resultMessageLabel.text = "mmm...\nlo siento, no es una palabra...\n¡sigue probando!"
                    
                    resultMessageLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
                }
                
            }
        }
    }
    
    func resetAllButtons(){
        
        for button in buttonsClicked {
            
            button.isSelected = false
            button.isEnabled = true
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        }
    }
    
    func clearData(){
        
        buttonsClicked.removeAll()

        myWordLabel.text?.removeAll()
        
    }
    
    

    @IBAction func newGameButtonClick(_ sender: UIButton) {
        
        print("new game")
        
        //let indexPath: NSIndexPath = NSIndexPath(row: 2, section: 0)
        
        
        
//        var numberOfCells: Int = collectionView.numberOfItems(inSection: 0)
//
//        for cell in collectionView.cellForItem(at: indexPath as IndexPath)
//
//
//
//        for (cell in collectionView.numberOfItems)
    
    }
    
 
    //    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    //
    //
    //    timer = Timer.init() //INICIALIZA EL OBJECTO
    //    timer.isValid // COMPRUEBA SI EL TIMER ESTA INICIALIZADO
    //    timer.invalidate() //NOS CANCELA EL TIMER
    //
    //    @objc func fire(){
    //        //CODe
    //    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wordResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell:TableViewCellResult = tableView.dequeueReusableCell(withIdentifier: "idTableCell", for: indexPath) as! TableViewCellResult
         
        let word:String = wordResults[indexPath.row]
        
        tableCell.wordOKLabel.text = word
        
         return tableCell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myWordLabel.text = selectedLetter
        
        self.tableViewResults.backgroundColor = #colorLiteral(red: 1, green: 0.4512977004, blue: 0.472446382, alpha: 1)
    }
    

    


}


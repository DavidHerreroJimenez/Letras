// Package: Letras,
// File name: ViewController.swift,
// Created by David Herrero on 25/11/2019.

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var letters = ["A", "B", "C", "F", "G", "H", "I", "N"]
    
    
    var time: Int = 0
    let maxTimeInSeconds: Int = 10
    let minTimeInSeconds: Int = 0
    var selectedLetter = ""
    var lastCharToRemove: String = ""
    var buttonsClicked: [UIButton] = []
    var allButtons: [UIButton] = []
    var wordResults: [String] = []
    
    
    var collectionView: UICollectionView?
    
    
    var timer: Timer?
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var resultMessageLabel: UILabel!
    @IBOutlet weak var tableViewResults: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameBtn: RoundButton!
    
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
        
        allButtons.append(cell.cellButton)
        
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
        
        
        if wordLabel.text != nil {
            
            wordLabel.text! += selectedLetter
            
        }else{
            wordLabel.text = ""
            
            wordLabel.text! += selectedLetter
        }
        
        buttonsClicked.append(sender)
        
    }
    
    
    @IBAction func deleteCharClick(_ sender: UIButton) {
        
        if wordLabel.text != nil && !wordLabel.text!.isEmpty {
            
            lastCharToRemove = String(wordLabel.text?.last ?? " ")
            
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

            wordLabel.text?.removeLast()
        }
        
    }
    
    
    @IBAction func checkWordClick(_ sender: UIButton) {
        
        if let wordToCheck =  wordLabel.text{
            if (!wordToCheck.isEmpty){
                
                let apiClient: APIClient = APIClient()
                 
                 apiClient.checkWord(word: wordToCheck, completion: { result in
                     
                     print("my result is: \(result)")
                    
                    
                    if (result){
                        self.wordResults.append(wordToCheck)
                        self.resultMessageLabel.textColor = #colorLiteral(red: 0, green: 0.7141116858, blue: 0.285058111, alpha: 1)
                        self.resultMessageLabel.text = "Palabra correcta!"
                        self.tableViewResults.reloadData()
                        self.resetClickedButtons()
                        self.clearData()
                                      
                    }else{
                        self.resultMessageLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
                        self.resultMessageLabel.text = "Lo siento,\nno es una palabra correcta...\n¡sigue intentándolo!"
                    }
                 })
                
            }
        }
    }
    

    
    

    @IBAction func newGameButtonClick(_ sender: UIButton) {
    
        sender.isEnabled = false
        
        resetClickedButtons()
        enableAllButtons()
        clearData()
        
        resultMessageLabel.text = ""
        wordResults.removeAll()
        
        time = maxTimeInSeconds
        
        timerLabel.text = formatTimeToTimer(time: time)
        
        
        
        if (timer?.isValid ?? false){
                  print("error: old timer is valid!!")
            
            timer?.invalidate() //NOS CANCELA EL TIMER
        }
              
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        
        
        timer = Timer.init() //INICIALIZA EL OBJECTO
        
        self.tableViewResults.reloadData()
    }
    

    
    @objc func fire(timer: Timer){
        
        if (time > minTimeInSeconds){
            time-=1
            timerLabel.text = formatTimeToTimer(time: time)
        }else{
            timer.invalidate() //NOS CANCELA EL TIMER

            resultMessageLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
            resultMessageLabel.text = "Vaya...\n...parece que se te ha acabado el tiempo..."
            
            newGameBtn.isEnabled = true
            
            disableAllButtons()
        }
    }
    
 

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wordResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell:TableViewCellResult = tableView.dequeueReusableCell(withIdentifier: "idTableCell", for: indexPath) as! TableViewCellResult
         
        let word:String = wordResults[indexPath.row]
        
        tableCell.wordOKLabel.text = word
        
         return tableCell
    }
    
    
    func resetClickedButtons(){
        
        for button in buttonsClicked {
            
            button.isSelected = false
            button.isEnabled = true
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        }
    }
    
    func disableAllButtons(){
        
        for button in  allButtons {
            
            button.isSelected = false
            button.isEnabled = false
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }
        
    }
    
    func enableAllButtons(){
        
        for button in  allButtons {
            
            button.isSelected = false
            button.isEnabled = true
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }
        
    }
    
    func clearData(){
        
        buttonsClicked.removeAll()

        wordLabel.text?.removeAll()
        
    }
    
    func formatTimeToTimer(time timeToTimer: Int) -> String{
        
        let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "ss"
        let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "mm:ss"

        if let date = dateFormatterGet.date(from: String(timeToTimer)) {
            return dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
            return "00:00"
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordLabel.text = selectedLetter
        
        self.tableViewResults.backgroundColor = #colorLiteral(red: 1, green: 0.4512977004, blue: 0.472446382, alpha: 1)
        
        disableAllButtons()
    }
    

    


}


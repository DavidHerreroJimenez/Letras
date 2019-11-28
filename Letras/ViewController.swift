// Package: Letras,
// File name: ViewController.swift,
// Created by David Herrero on 25/11/2019.

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var letters = ["A", "B", "C", "F", "G", "H", "I", "N"]
    
    
    var time: Int = 0
    let maxTimeInSeconds: Int = 59
    let minTimeInSeconds: Int = 0
    
    var bonusTime: Int = 0
    let maxBonusTimeInSeconds: Int = 4
    let minBonusTimeInSeconds: Int = 0
    
    var currentBonus = 1
    var totalScore = 0
    
    var selectedLetter = ""
    var lastCharToRemove: String = ""
    var buttonsClicked: [UIButton] = []
    var allButtons: [UIButton] = []
    var wordResults: [String] = []
    var wordPointsResult: [Int] = []
    
    
    var collectionView: UICollectionView?
    
    
    var timer: Timer?
    var bonusTimer: Timer?
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var resultMessageLabel: UILabel!
    @IBOutlet weak var tableViewResults: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameBtn: RoundButton!
    @IBOutlet weak var deleteCharBtn: RoundButton!
    @IBOutlet weak var checkWordBtn: RoundButton!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalWordsLabel: UILabel!
    
    
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
        cell.cellButton.isEnabled = false
        
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
            //if (!wordToCheck.isEmpty){
                
                let apiClient: APIClient = APIClient()
                 
                 apiClient.checkWord(word: wordToCheck, completion: { result in
                     
                     print("my result is: \(result)")
                    
                    
                    if (result){
                        
                        let wordPoints = self.calculatePoints(word: wordToCheck)
                        
                        self.wordResults.append(wordToCheck)
                        self.wordPointsResult.append(wordPoints)
                        self.resultMessageLabel.textColor = #colorLiteral(red: 0, green: 0.7141116858, blue: 0.285058111, alpha: 1)
                        self.resultMessageLabel.text = "Palabra correcta!"
                        self.tableViewResults.reloadData()
                        self.resetClickedButtons()
                        self.clearData()
                        
                        //bonus x2 if word wrote before 4 seconds
                        //reset timer interval
                        self.initBonusTimer()
                        
                        self.totalScore += wordPoints
                                      
                    }else{
                        self.resultMessageLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
                        self.resultMessageLabel.text = "Lo siento,\nno es una palabra correcta...\n¡sigue intentándolo!"
                        
                        //reset bonus
                        //reset puntuacion bonus
                        self.cancelBonusTimer()
                        
                    }
                 })
                
            //}
        }
    }
    

    

    @IBAction func newGameButtonClick(_ sender: UIButton) {
        resetClickedButtons()
        enableAllButtonCells()
        clearData()
        
        resultMessageLabel.text = ""
        wordResults.removeAll()
        wordPointsResult.removeAll()
        
        
        totalScore = 0
        
        totalScoreLabel.text = "0"
        totalWordsLabel.text = "0"
        
        time = maxTimeInSeconds
        
        
        
        
        timerLabel.text = formatTimeToTimer(time: time)
        
        
        
        if (timer?.isValid ?? false){
                  print("error: old timer is valid!!")
            
            timer?.invalidate() //NOS CANCELA EL TIMER
        }
              
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        
        
        timer = Timer.init() //INICIALIZA EL OBJECTO
        
        self.tableViewResults.reloadData()
        
        prepareGameBtnsToPlay()
        
        

    }
    

    
    @objc func fire(timer: Timer){
        
        if (time > minTimeInSeconds){
            time-=1
            timerLabel.text = formatTimeToTimer(time: time)
        }else{
            timer.invalidate() //NOS CANCELA EL TIMER
            
            cancelBonusTimer()

            resultMessageLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
            resultMessageLabel.text = "Vaya...\n...parece que se te ha acabado el tiempo..."
            
            
            prepareGameBtnsBeforePlay()
            
            disableAllButtonCells()
        }
    }
    
 

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wordResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell:TableViewCellResult = tableView.dequeueReusableCell(withIdentifier: "idTableCell", for: indexPath) as! TableViewCellResult
         
        let word:String = wordResults[indexPath.row]
        let wordScore: Int = wordPointsResult[indexPath.row]
        
        tableCell.wordOKLabel.text = word
        tableCell.wordScoreLabel.text = "+" + String(wordScore)
        
        totalScoreLabel.text = String(totalScore)
        
        totalWordsLabel.text = String(wordResults.count)
        
        
         return tableCell
    }
    
    
    func resetClickedButtons(){
        
        for button in buttonsClicked {
            
            button.isSelected = false
            button.isEnabled = true
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        }
    }
    
    func disableAllButtonCells(){
        
        for button in  allButtons {
            
            button.isSelected = false
            button.isEnabled = false
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }
        
    }
    
    func enableAllButtonCells(){
        
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
    
    func prepareGameBtnsBeforePlay(){
        
        deleteCharBtn.isEnabled = false
        checkWordBtn.isEnabled = false
        newGameBtn.isEnabled = true
    }
    
    func prepareGameBtnsToPlay(){
        
        newGameBtn.isEnabled = false
        deleteCharBtn.isEnabled = true
        checkWordBtn.isEnabled = true
    }
    
    func initBonusTimer(){
        
        UIHelper.showToast(controller: self, message: "It's BONUS time!", seconds: 2)
        
        bonusTime = maxBonusTimeInSeconds
            
        if (bonusTimer?.isValid ?? false){
                  print("error: old bonusTimer is valid!!")
            
            bonusTimer?.invalidate() //NOS CANCELA EL bonusTimer
        }
              
        
        bonusTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireBonus), userInfo: nil, repeats: true)
        
        
        bonusTimer = Timer.init() //INICIALIZA EL OBJECTO bonusTimer
        
        
    }
    
    @objc func fireBonus(bonusTimer: Timer){
        
        if (bonusTime > minBonusTimeInSeconds){
            print(bonusTime)
            bonusTime-=1
            
         }else{
             bonusTimer.invalidate() //NOS CANCELA EL TIMER
            
            print("end bonus timer: \(bonusTime)")
             
         }
    }
    
    func cancelBonusTimer(){
        
        bonusTimer?.invalidate()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordLabel.text = selectedLetter
        
        self.tableViewResults.backgroundColor = #colorLiteral(red: 1, green: 0.4512977004, blue: 0.472446382, alpha: 1)
        
        prepareGameBtnsBeforePlay()
        
    }
    

    func calculatePoints(word: String) -> Int{
        
        return word.count * currentBonus
    }
    

    
    


}


// Package: Letras,
// File name: APIClient.swift,
// Created by David Herrero on 27/11/2019.

import Alamofire

class APIClient{
    
    enum WordErrors: Error{
        
        case isEmpty
        case isTooLong
        case unknown
    }
    
    func checkWord(word: String, completion: @escaping(_ result:Bool) -> Void){
        
        print(word)
        
        if (validateWord(wordToValidate: word)){
            
            let url = "https://store.apicultur.com/api/corrige-palabra/1.0.0/" + word
            let headers: HTTPHeaders = [
                "Authorization": "Bearer uHS_7Q2Esg7XsUKNsaqFx2sB1mca",
                "Accept": "application/json"]
            
            AF.request(url,headers: headers).responseJSON { response in
                
                
                
                
                switch(response.result){
                case .success(let result):
                    
                    print(result)
                    let arrayResult = result as! NSArray
                    
                    if (arrayResult.count > 0){
                        let parsed = arrayResult[0] as! NSDictionary
                        
                        print(parsed["palabra_error"] ?? "no value")
                        completion(false)
                    }else{
                        completion(true)
                    }
                    
                case .failure:
                    print("ERROR REQUEST")
                    completion(false)
                    
                }
                
            }
        }
    }
    
    
    
    func validateWord(wordToValidate: String) -> Bool{
        
        do {
            
            try isWordEmpty(wordToCheck: wordToValidate)
            
            return true
        }catch{
            
            print(error)
            
            return false
        }
        
        
    }
    
    
    func isWordEmpty(wordToCheck: String) throws{
        
        if wordToCheck.isEmpty {
            
            throw WordErrors.isEmpty
            
        }
        
    }
    

}

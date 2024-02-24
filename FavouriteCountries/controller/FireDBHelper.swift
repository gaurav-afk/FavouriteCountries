
import Foundation
import FirebaseFirestore

class FireDBHelper : ObservableObject{
    
    @Published var countryList = [FavCountry]()
    
    private let db : Firestore
    private static var shared : FireDBHelper?
    private let COLLECTION_COUNTRY : String = "User_Country"
    private let COUNTRY_NAME : String = "title"
    
    init(db : Firestore){
        self.db = db
    }
    
    static func getInstance() -> FireDBHelper{
        if (shared == nil){
            shared = FireDBHelper(db: Firestore.firestore())
        }
        return shared!
    }

    
    func addCountry(newCountry: FavCountry) {
        let countryRef = db.collection(COLLECTION_COUNTRY).document(newCountry.name)
        
        countryRef.setData([
            "capital": newCountry.capital,
            "name": newCountry.name,
            "population": newCountry.population,
            "flags": newCountry.flag,
            "region": newCountry.region
        ], merge: true) { error in // merge is set to true to ensure that the document is added only once.
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added/updated successfully")
            }
        }
    }
    
    func getAllCountry(){
            
            self.db.collection(COLLECTION_COUNTRY)
                .addSnapshotListener({ (querySnapshot, error) in
                    
                    guard let snapshot = querySnapshot else{
                        print(#function, "Unable to retrieve data from firestore : \(error)")
                        return
                    }
                    
                    snapshot.documentChanges.forEach{ (docChange) in
                        
                        do{

                            var favCountry : FavCountry = try docChange.document.data(as: FavCountry.self)
                            favCountry.id = docChange.document.documentID
                            
                            let matchedIndex = self.countryList.firstIndex(where: {($0.id?.elementsEqual(docChange.document.documentID))!})
                            
                            switch(docChange.type){
                            case .added:
                                print(#function, "Document added : \(docChange.document.documentID)")
                                self.countryList.append(favCountry)
                            case .modified:
                                print(#function, "Document updated : \(docChange.document.documentID)")
                                if (matchedIndex != nil){
                                    self.countryList[matchedIndex!] = favCountry
                                }
                            case .removed:
                                print(#function, "Document removed : \(docChange.document.documentID)")
                                if (matchedIndex != nil){
                                    self.countryList.remove(at: matchedIndex!)
                                }
                            }
                            
                        }catch let err as NSError{
                            print(#function, "Unable to convert document into Swift object : \(err)")
                        }
                        
                    }//forEach
                })
        
    }//getAllCountry
    
    
    func deleteCountry(countryToDelete : FavCountry){
        
        if(countryToDelete.id != nil){
            self.db.collection(COLLECTION_COUNTRY)
                .document(countryToDelete.id!)
                .delete{error in
                    if let err = error{
                        print(#function, "Unable to delete document : \(err)")
                    }else{
                        print(#function, "successfully deleted : \(countryToDelete.name)")
                    }
                }
        } else {
            print(#function, "unable to delete")
        }
      
    }
    
    
}

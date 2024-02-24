

import SwiftUI

struct CountryList: View {
    @State var countyList:[Country] = []
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    var body: some View {
        VStack {
            HStack {
                Text("COUNTRIES")
                Image(systemName: "globe")
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            
            NavigationStack{
            List {
                ForEach(countyList, id: \.name.common) {
                    country in
                        NavigationLink {
                            CountryDetail(country: country as Country)
                                .environmentObject(self.fireDBHelper)
                        } label: {
                            HStack {
                                Text(country.name.common)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            loadDataFromAPI()
        }
    }   // body
    
    
    
    
    
    
    
    
    
    func loadDataFromAPI() {
        print("Getting data from API")
        
        let websiteAddress:String = "https://restcountries.com/v3.1/all"
        
        guard let apiURL = URL(string: websiteAddress) else {
            print("ERROR: Cannot convert api address to an URL object")
            return
        }
        
        let request = URLRequest(url:apiURL)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data:Data?, response, error:Error?) in

   
            if let error = error {
                print("ERROR: Network error: \(error)")
                return
            }
            

            if let jsonData = data {
                print("data retreived")
                
                if let decodedResponse =
                    try? JSONDecoder().decode([Country].self, from:jsonData) {
                    DispatchQueue.main.async {
                        print(decodedResponse)
                        self.countyList = decodedResponse
                    }
                }
                
                else {
                    print("ERROR: Error converting data to JSON")
                }
            }
            else {
                print("ERROR: Did not receive data from the API")
            }
        }
        task.resume()

        
    }
} // ContentView

#Preview {
    CountryList()
}

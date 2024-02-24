

import SwiftUI
import Toast

struct CountryDetail: View {
    let country: Country?
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    var body: some View {
        VStack{
            Spacer()
            
            if let flagURL = country?.flags.png{
                AsyncImage(url:URL(string: flagURL))
            } else {
                Text("Flag not available")
            }
            if let countryName = country?.name.common {
                Text(countryName)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            } else {
                Text("Country name not available")
            }
            if let capitalName = country?.capital?[0] {
                Text("capital: \(capitalName)")
            } else {
                Text("Capital name not available")
            }
            if let region = country?.region {
                Text("region: \(region)")
            } else {
                Text("region not available")
            }
            if let population = country?.population {
                Text("Population: \(population)")
            } else {
                Text("Population not available")
            }
            
            Spacer()
            
            Button{

                if let commonName = country?.name.common,
                       let firstCapital = country?.capital?.first,
                       let population = country?.population,
                       let flagURL = country?.flags.png,
                       let region = country?.region {
                        
                        let newCountry = FavCountry(name: commonName,
                                                     capital: firstCapital,
                                                     population: population,
                                                     flag: flagURL,
                                                     region: region)
                        
                    fireDBHelper.addCountry(newCountry: newCountry)
                    
                    
                    
                    let toast = Toast.text("\(commonName) added to favourite list")
                    toast.show()
                    } else {
                        print("One or more required properties are nil")
                    }
                
            }label: {
                HStack {
                    Text("Favourite")
                    Image(systemName: "star")
                }
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            
            Spacer()
        }
    }
}



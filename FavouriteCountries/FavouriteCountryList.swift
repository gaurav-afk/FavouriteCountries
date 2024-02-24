

import SwiftUI

struct FavouriteCountryList: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @State var canDelete: Bool = false
    @State var isConfirmationAlertShown: Bool = false
    @State private var selectedIndices: IndexSet = []
    
    var body: some View {
        VStack{
            
            if(self.fireDBHelper.countryList.isEmpty){
                
                VStack{
                    Spacer()
                    HStack{
                        Text("No favourites")
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "star.slash.fill")
                            .foregroundColor(.orange)
                    }
                    .font(.largeTitle)
                }
                Spacer()
            }
            
            List{
                ForEach(self.fireDBHelper.countryList.enumerated().map({$0}), id: \.element.self){_, currCountry in
                   
                    HStack{
                        Text("\(currCountry.name)")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if let capital = currCountry.capital {
                            Text(capital)
                        } else {
                            Text("N/A")
                        }
                    }
                }
                
                .onDelete(perform: { indexSet in
                    isConfirmationAlertShown = true
                    self.selectedIndices = indexSet // Storing indexSet for later use
                })

                .alert(isPresented: $isConfirmationAlertShown) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Do you want to remove the country?"),
                        primaryButton: .default(Text("Confirm")) {
                            for index in selectedIndices {
                                self.fireDBHelper.deleteCountry(countryToDelete: self.fireDBHelper.countryList[index])
                            }
                            // Reseting selectedIndices after deletion
                            selectedIndices.removeAll()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }//List
        }
        
    }
}

#Preview {
    FavouriteCountryList()
}

//
//  CreditsView.swift
//  ballbr3aker
//
//  Created by Анохин Юрий on 02.06.2023.
//

import SwiftUI

struct CreditsView: View { // horrible code coems :money:
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("CVE-1488-ELDA")
                        Text("By s0meyosh1no")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Button("Link") {
                        UIApplication.shared.open(URL(string: "https://pornhub.com")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("CVE-1488-HUETA")
                        Text("By latte_1, Andrew Sosov")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Button("Link") {
                        UIApplication.shared.open(URL(string: "https://onlyfans.com")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                    
                    
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("GarlicMonster, OnionStar")
                        Text("By SalupovTeam")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Button("Link") {
                        UIApplication.shared.open(URL(string: "https://github.com/slds1/GarlicMonster")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Thanks to everyone else!!!")
                        Text("llsc12 - respring bug from ballpa1n\n\nHaxi0 - ballsbr3aker app UI\n\nAndrew Sosov - pidarasi")
                            .font(.system(size: 12))
                            .opacity(0.5)
                        
                    }
                }
            }
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}

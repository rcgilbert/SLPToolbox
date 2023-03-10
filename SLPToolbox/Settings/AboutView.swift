//
//  AboutView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/23/22.
//

import SwiftUI

struct AboutView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("SLP Toolbox is a suite of quick tools to make common tasks for _Speech and Language Pathologists_ a little quicker and easier. It is not meant as a treatment or medical tool and is provided without warranty. \n\nThis app was conceived and designed by **Speechie Adventures**.")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                    Spacer()
                    HStack {
                        Spacer()
                        Image("sa-logo")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle("About")
            .toolbar {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
       
    }
}

struct AboutView_Previews: PreviewProvider {
    @State static var isPresented: Bool = true
    static var previews: some View {
        AboutView(isPresented: $isPresented)
    }
}

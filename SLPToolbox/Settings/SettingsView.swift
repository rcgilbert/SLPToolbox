//
//  SettingsView.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 12/23/22.
//

import SwiftUI

struct SettingsView: View {
    @State var aboutIsPresented: Bool = false
    
    enum Social {
        case instagram
        case facebook
        case pinterest
        case website
    }
    
    var body: some View {
        Form {
            Section("Socials") {
                Button {
                    openSocial(.instagram)
                } label: {
                    Label {
                        Text("Instagram")
                    } icon: {
                        Image("instagram-icon")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(2)
                    }
                }
                Button {
                    openSocial(.facebook)
                } label: {
                    Label {
                        Text("Facebook")
                    } icon: {
                        Image("facebook-icon")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(2)
                    }
                }
                Button {
                    openSocial(.pinterest)
                } label: {
                    Label {
                        Text("Pinterest")
                    } icon: {
                        Image("pinterest-icon")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(2)
                    }
                }
                Button {
                    openSocial(.website)
                } label: {
                    Label("Speechie Adventures", systemImage: "globe")
                }

            }
            Section {
                Button {
                    aboutIsPresented.toggle()
                } label: {
                    Label("About", systemImage: "info.circle")
                }

                Button {
                    openMail()
                } label: {
                    Label("Contact", systemImage: "envelope")
                }
            }
        }.sheet(isPresented: $aboutIsPresented) {
            AboutView(isPresented: $aboutIsPresented)
        }
    }
    
    private func openMail() {
        guard let url = URL(string: "mailto:slptoolbox@speechieadventures.com?subject=%5BSLPToolbox%5D&body=%5B%5D") else {
            assertionFailure("Mail URL broken!")
            return
        }
        UIApplication.shared.open(url)
    }
    
    private func openSocial(_ social: Social) {
        var url: URL?
        switch social {
        case .facebook:
            url = URL(string: "https://www.facebook.com/speechieadventures")
        case .instagram:
            url = URL(string: "https://www.instagram.com/speechieadventures")
        case .pinterest:
            url = URL(string: "https://www.pinterest.com/speechieadventures/")
        case .website:
            url = URL(string: "https://www.speechieadventures.com/")
        }
        
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

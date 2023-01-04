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
        
        var url: URL! {
            switch self {
            case .website:
                return URL(string: "https://www.speechieadventures.com/")
            case .instagram:
                return URL(string: "https://www.instagram.com/speechieadventures")
            case .facebook:
                return URL(string: "https://www.facebook.com/speechieadventures")
            case .pinterest:
                return URL(string: "https://www.pinterest.com/speechieadventures/")
            }
        }
    }
    
    var body: some View {
        Form {
            Section("Socials") {
                Link(destination: Social.instagram.url) {
                    Label {
                        Text("Instagram")
                    } icon: {
                        Image("instagram-icon")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(2)
                    }
                }
                Link(destination: Social.facebook.url) {
                    Label {
                        Text("Facebook")
                    } icon: {
                        Image("facebook-icon")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(2)
                    }
                }
                Link(destination: Social.pinterest.url) {
                    Label {
                        Text("Pinterest")
                    } icon: {
                        Image("pinterest-icon")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(2)
                    }
                }
                Link(destination: Social.website.url) {
                    Label("Speechie Adventures", systemImage: "globe")
                }

            }
            Section {
                Button {
                    aboutIsPresented.toggle()
                } label: {
                    Label("About", systemImage: "info.circle")
                }

                Link(destination: getMailURL()) {
                    Label("Contact", systemImage: "envelope")
                }
            }
        }.sheet(isPresented: $aboutIsPresented) {
            AboutView(isPresented: $aboutIsPresented)
        }
    }
    
    private func getMailURL() -> URL! {
        let deviceInfoString = "\(Bundle.main.versionString ?? "")(\(Bundle.main.versionString ?? ""))"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "mailto:slptoolbox@speechieadventures.com?subject=%5BSLPToolbox%5D&body=%5B\(deviceInfoString)%5D")!
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

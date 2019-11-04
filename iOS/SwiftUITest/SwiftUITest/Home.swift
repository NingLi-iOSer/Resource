//
//  Home.swift
//  SwiftUITest
//
//  Created by Ning Li on 2019/7/15.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct Home : View {
    
    @State var show: Bool = false
    @State var showProfile = false
    
    var body: some View {
        ZStack {
            
            HomeList()
                .blur(radius: show ? 20 : 0)
                .scaleEffect(showProfile ? 0.95 : 1)
            .animation(.default)
            
            ContentView()
                .cornerRadius(20)
                .shadow(radius: 20)
                .animation(.interactiveSpring())
                .offset(y: showProfile ? 40 : UIScreen.main.bounds.height)
            
            MenuButton(show: $show)
                .animation(.interactiveSpring())
                .offset(x: -30, y: showProfile ? 0 : 80)
            
            MenuRight(showProfile: $showProfile)
                .animation(.interactiveSpring())
                .offset(x: -16, y: showProfile ? 0 : 88)
            
            MenuView(menus: menuItems, show: $show)
        }
    }
}

#if DEBUG
struct Home_Previews : PreviewProvider {
    static var previews: some View {
        Home()
    }
}
#endif

struct MenuRow: View {
    var image: String = ""
    var title: String = ""
    var body: some View {
        return HStack {
            Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(Color("icons"))
                .frame(width: 32, height: 32)
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}

struct MenuView: View {
    var menus: [Menu]
    @Binding var show: Bool
    var body: some View {
        return VStack(alignment: .leading, spacing: 20) {
            ForEach(menus) { item in
                MenuRow(image: item.icon, title: item.title)
            }
            Spacer()
        }
        .padding(.top, 20)
        .padding(30)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.trailing, 60)
        .shadow(radius: 20)
        .rotation3DEffect(.degrees(show ? 0 : 60), axis: (x: 0, y: 10, z: 0))
        .animation(.default)
        .offset(x: show ? 0 : -UIScreen.main.bounds.width)
        .onTapGesture {
            self.show.toggle()
        }
    }
}

struct MenuButton: View {
    @Binding var show: Bool
    var body: some  View {
        return ZStack(alignment: .topLeading) {
            Button(action: { self.show.toggle() }) {
                HStack() {
                    Spacer()
                    Image(systemName: "list.dash")
                        .foregroundColor(Color.black)
                }
                .padding(.trailing, 20)
                    .frame(width: 90, height: 60)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: Color("buttonShadow"), radius: 10, x: 0, y: 10)
            }
            Spacer()
        }
    }
}

struct CircleButton: View {
    var icon: String
    var body: some View {
        return HStack {
            Image(systemName: icon)
                .foregroundColor(Color.black)
        }
        .frame(width: 44, height: 44)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: Color("buttonShadow"), radius: 10, x: 0, y: 10)
    }
}

struct MenuRight: View {
    @Binding var showProfile: Bool
    var body: some View {
        return ZStack(alignment: .topTrailing) {
            HStack {
                Button(action: { self.showProfile.toggle() }) {
                    CircleButton(icon: "person.crop.circle")
                }
                Button(action: { self.showProfile.toggle() }) {
                    CircleButton(icon: "bell")
                }
            }
            Spacer()
        }
    }
}

struct Menu: Identifiable {
    var id = UUID()
    var title: String
    var icon: String
}

let menuItems = [Menu(title: "My Account", icon: "person.crop.circle"),
                 Menu(title: "Billding", icon: "creditcard"),
                 Menu(title: "Team", icon: "person.and.person"),
                 Menu(title: "Sing out", icon: "arrow.uturn.down")]

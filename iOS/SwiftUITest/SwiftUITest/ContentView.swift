//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Ning Li on 2019/7/3.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @State var show: Bool = false
    @State var viewState = CGSize.zero
    
    var body: some View {
        ZStack {
            
            BlurView(style: .light)
            
            TitleView()
                .blur(radius: show ? CGFloat(20) : CGFloat(0))
//                .blur(radius: show ? CGFloat(20) : CGFloat(0))
                .animation(.easeOut(duration: 0.3))
            
            CardBottomView()
                .blur(radius: show ? 20 : 0)
                .animation(.basic(duration: 0.3, curve: .easeOut))
            
            CardView()
//                .background(show ? Color("background3") : Color("background5"))
                .cornerRadius(10)
                .shadow(radius: 20)
                .offset(x: 0, y: show ? -400 : -40)
                .scaleEffect(0.85)
                .rotationEffect(Angle(degrees: show ? 15 : 0))
                .blendMode(.hardLight)
                .animation(Animation.easeOut(duration: 0.6))
                .offset(viewState)
            
            CardView()
                .background(Color.black)
                .cornerRadius(10)
                .shadow(radius: 20)
                .offset(x: 0, y: show ? -200 : -20)
                .scaleEffect(0.9)
                .rotationEffect(Angle(degrees: show ? 10 : 0))
                .blendMode(.hardLight)
                .animation(Animation.easeOut(duration: 0.4))
                .offset(viewState)
            
            CertificateView(certificate: Certificate(title: "UI Design", image: "Certificate1", width: 340, height: 220))
            CertificateView(certificate: Certificate(title: "UI Design", image: "Certificate1", width: 340, height: 220))
                .offset(x: viewState.width, y: viewState.height)
                .rotationEffect(Angle(degrees: show ? 5 : 0))
//                .scaleEffect(0.95)
//                .scaleEffect(0.95)
                .animation(.spring())
                .onTapGesture {
                    self.show.toggle()
                }
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            self.viewState = value.translation
                            self.show = true
                        })
                        .onEnded({ (value) in
                            self.viewState = CGSize.zero
                            self.show = false
                        })
                )
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct CardView: View {
    var body: some View {
        return VStack {
            Text("Card")
                .font(.headline)
            }
            .frame(width: 340, height: 220)
            .cornerRadius(10)
            .shadow(radius: 20)
    }
}

struct CertificateView: View {
    var certificate = Certificate(title: "UI Design", image: "Certificate1", width: 230, height: 150)
    var body: some View {
        return VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(certificate.title)
                        .font(.headline)
                        .foregroundColor(Color("accent"))
                        .padding(.top)
                    Text("Certificate")
                        .foregroundColor(Color.white)
                }
                Spacer()
                Image("Logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                }
                .padding(.horizontal)
            Spacer()
            Image(certificate.image)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .offset(y: 50)
            }
            .frame(width: CGFloat(certificate.width), height: CGFloat(certificate.height))
            .background(Color.black)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

struct TitleView: View {
    var body: some View {
        return VStack(spacing: 20) {
            Text("Certificate")
                .font(.title)
                .fontWeight(.bold)
            Image("Illustration5")
            Spacer()
        }
    }
}

struct CardBottomView: View {
    var body: some View {
        return VStack {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3)
                .opacity(0.1)
            Text("This certificate is proof that Meng To has achieved the UI Design course with approval from a Design+Code instructor.")
                .lineLimit(0)
            Spacer()
            }
            .padding()
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 20)
            .offset(y: 600)
    }
}

//
//  HomeList.swift
//  SwiftUITest
//
//  Created by Ning Li on 2019/7/15.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI

struct HomeList : View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    VStack {
                        Text("Courses")
                            .font(.title)
                        Text("22 courses")
                            .color(.gray)
                    }
                    .padding(.leading, 78)
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach (coursesData) { item in
                            NavigationLink(destination: ContentView()) {
                                GeometryReader { (geometry) in
                                    CourseView(course: item)
                                        .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 40) / -20), axis: (x: 0, y: 10, z: 0))
                                }
                                .frame(width: 246, height: 360)
                            }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.leading, 40)
                    Spacer()
                }
                .frame(height: 450)
                
                CertificateRow()
            }
            .padding(.top, 80)
        }
    }
}

#if DEBUG
struct HomeList_Previews : PreviewProvider {
    static var previews: some View {
        HomeList()
    }
}
#endif

struct CourseView: View {
    var course: Course
    var body: some View {
        return VStack(alignment: .leading) {
            Text(course.title)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(4)
                .padding(30)
                .foregroundColor(Color.white)
                .padding(.trailing, 50)
            Spacer()
            Image(course.image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 246, height: 150)
                .padding(.bottom, 30)
        }
        .frame(width: 246, height: 360)
            .background(course.color)
            .cornerRadius(20)
            .shadow(color: course.shadowColor, radius: 20, x: 0, y: 20)
    }
}

struct Course: Identifiable {
    var id = UUID()
    var title: String
    var image: String
    var color: Color
    var shadowColor: Color
}

let coursesData = [
    Course(title: "Build an app with SwiftUI",
           image: "Illustration1",
           color: Color("background3"),
           shadowColor: Color("backgroundShadow3")),
    Course(title: "Design and animate your UI",
           image: "Illustration2",
           color: Color("background4"),
           shadowColor: Color("backgroundShadow4")),
    Course(title: "Swift UI Advanced",
           image: "Illustration3",
           color: Color("background7"),
           shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
    Course(title: "Framer Playground",
           image: "Illustration4",
           color: Color("background8"),
           shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
    Course(title: "Flutter for Designers",
           image: "Illustration5",
           color: Color("background9"),
           shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]

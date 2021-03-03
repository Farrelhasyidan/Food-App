//
//  Home.swift
//  Food App
//
//  Created by Farrel hasyidan on 01/03/21.
//

import SwiftUI

struct Home: View {
  @StateObject var HomeModel = HomeViewModel()
  var body: some View{
    ZStack{
      VStack(spacing: 10){
        HStack(spacing: 15){
          
          Button(action: {
            withAnimation(.easeIn){HomeModel.showMenu.toggle()}
          }, label: {
            Image(systemName: "line.horizontal.3")
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
              .foregroundColor(Color.pink)
          })
          
          Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver to")
            .foregroundColor(.black)
          
          Text(HomeModel.userAddress)
            .font(.caption)
            .fontWeight(.heavy)
            .foregroundColor(.pink)
          Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
        }
        .padding([.horizontal,.top])
        
        Divider()
        
        HStack(spacing: 15){
          
          Image(systemName: "magnifyingglass")
            .font(.title)
            .foregroundColor(.gray)
          
          TextField("Search", text: $HomeModel.search)
          
          if HomeModel.search != "" {
            Button (action: {}, label: {
              Image(systemName: "magnifying")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
            })
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
          }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        
        Divider()
        
        ScrollView(.vertical, showsIndicators: false, content : {
          VStack(spacing: 25){
            ForEach(HomeModel.filtered){ item in
              ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                
                ItemView(item: item)
                
                HStack{
                  Text("FREE DELIVERY")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.pink)
                  
                  Spacer(minLength: 0)
                  
                  Button(action: {}, label: {
                    Image(systemName: "plus")
                      .foregroundColor(.white)
                      .padding(10)
                      .background(Color.pink)
                      .clipShape(Circle())
                  })
                }
                .padding(.trailing, 10)
                .padding(.top, 10)
              })
              .frame(width: UIScreen.main.bounds.width - 30)
            }
          }
          .padding(.top, 30)
        })
        
      }
      
      HStack{
        Menu(homeData: HomeModel)
          .offset(x: HomeModel.showMenu ? 0.3 : -UIScreen.main.bounds.width / 1.6)
        
        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
      }
      .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                    .onTapGesture(perform: {
                      withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    })
      )
      if HomeModel.noLocation{
        Text("Please Enable Location Access in Settings To Futher Move on !!")
          .foregroundColor(.black)
          .frame(width: UIScreen.main.bounds.width - 100, height: 120)
          .background(Color.white)
          .cornerRadius(10)
          .frame(maxWidth:. infinity, maxHeight: .infinity)
          .background(Color.black.opacity(0.3).ignoresSafeArea())
      }
    }
    .onAppear(perform: {
      HomeModel.locationManager.delegate = HomeModel
    })
    .onChange(of: HomeModel.search, perform: { value in
      
      //to avoid continues search request
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
        if value == HomeModel.search && HomeModel.search != ""{
          //search Data
          HomeModel.filterData()
        }
      }
      if HomeModel.search == ""{
        //reset all data
        withAnimation(.linear){HomeModel.filtered = HomeModel.items}
      }
    })
  }
}


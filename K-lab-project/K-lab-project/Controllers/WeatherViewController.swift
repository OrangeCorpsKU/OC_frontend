
//  WeatherViewTest.swift
//  TestApp
//
//  Created by 허준호 on 11/1/23.
//

import SwiftUI

struct WeatherViewController: View {
    
    //버튼을 눌렀을 때 액션들을 수행하기 위한 State 값들입니다.
    @State private var firstButtonColor: Color = Color.yellow
    @State private var secondButtonColor: Color = Color.gray
    @State private var shadowOption: CGFloat = 2
    @State private var noneShadowOption: CGFloat = 0
    
    
    var body: some View {
        VStack{
            //위의 버튼 영역입니다.
            HStack(spacing:4){
                Button("News") {
                    withAnimation{
                        //비활성화 상태의 색깔에서 버튼을 눌렀을 때 색깔을 바꿔주는 Action을 취하도록 하죠
                        if firstButtonColor == Color.gray
                        {
                            firstButtonColor = Color.yellow
                            secondButtonColor = Color.gray
                        }
                    }
                }
                .frame(width: 132, height: 52)
                .foregroundColor(.black)
                .background(firstButtonColor)
                .cornerRadius(10)
                
                Button("Weather") {
                    withAnimation{
                        //비활성화 상태의 색깔에서 버튼을 눌렀을 때 색깔을 바꿔주는 Action을 취하도록 하죠
                        if secondButtonColor == Color.gray
                        {
                            firstButtonColor = Color.gray
                            secondButtonColor = Color.yellow
                        }
                    }
                }
                .frame(width: 132, height: 52)
                .foregroundColor(.black)
                .background(secondButtonColor)
                .cornerRadius(10)
            }
            .frame(width: 280, height: 64)
            .background(Color.gray)
            .cornerRadius(10)
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        
        
    }
}

#Preview {
    WeatherViewController()
}

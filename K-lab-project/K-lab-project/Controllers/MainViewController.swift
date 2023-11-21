//
//  MainViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/30.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, UITextViewDelegate {
    
    // Country Label
    @IBOutlet weak var loverCountry: UILabel!
    @IBOutlet weak var myCountry: UILabel!
    
    //Time Label
    @IBOutlet weak var loverTime: UILabel!
    @IBOutlet weak var myTime: UILabel!
    
    
    //
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    
    @IBOutlet weak var tidView: UIView!
    var questionState: QuestionState = .myQuestion
    //아직 입력하지 않았다는 레이블
    var label: UILabel!
    // 보기 버튼
    var viewAnswerButton: UIButton!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //UI set
        updateUI()
        
    }
    
    // time set
    @objc func updateTime() {
        setCurrentTimeForCountry(loverCountry, loverTime)
        setCurrentTimeForCountry(myCountry,myTime)
    }
    
    func setCurrentTimeForCountry(_ countryLabel: UILabel, _ timeLabel: UILabel) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // label값에 따라 TimeZone을 설정
        switch countryLabel.text {
        case "Netherlands":
            dateFormatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")
        case "Korea":
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        case "USA":
            dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
        case "China":
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        case "Japan":
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        default:
            // 기본값: 현재타임존
            dateFormatter.timeZone = TimeZone.current
        }
        
        dateFormatter.dateFormat = "HH:mm"
        
        let currentTime = dateFormatter.string(from: Date())
        
        // 받은 Label의 text 속성에 현재 시간 설정
        timeLabel.text = currentTime
    }
    
    // tidView 클릭시
    @objc func tidViewTapped() {
        UIView.transition(with: tidView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.tidView.subviews.forEach { subview in
                subview.isHidden = false
            }
            self.viewAnswerButton.isHidden = true
            self.saveButton.isHidden = false
            
            // 입력하지 않았다는 label 제거
            self.label?.removeFromSuperview()
        }, completion: { (completed) in
            if let tapGesture = self.tidView.gestureRecognizers?.first {
                self.tidView.removeGestureRecognizer(tapGesture)
            }
            
            // tapGesture 추가
            let newTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tidViewTapped))
            self.tidView.addGestureRecognizer(newTapGesture)
            

            

        })
    }

    
    
    func updateUI() {
        
        //1초마다 타이머 업데이트
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        switch questionState {
        case .myQuestion:
            // 내가 입력한 질문, 아직 답하지 않음
            answerTextView.isHidden = false
            saveButton.isHidden = false
            
            // 여기에서 inputAccessoryView를 사용하기 전에 nil 체크를 합니다.
            if let inputAccessoryView = answerTextView.inputAccessoryView {
                inputAccessoryView.isHidden = false
            }
        case .opponentQuestionNotAnswered:
            // 상대방이 입력한 질문, 아직 답하지 않음
            answerTextView.isHidden = false
            saveButton.isHidden = true
        case .opponentQuestionAnsweredHidden:
            // 상대방이 입력한 질문, 답이 있음 (답이 숨겨진 상태)
            saveButton.isHidden = true
            showButtonmaker()
            
        case .opponentQuestionAnsweredVisible:
            // 상대방이 입력한 질문, 답이 있음 (답이 표시된 상태)
            answerTextView.isHidden = true
            saveButton.isHidden = true
            // 상대방의 답 표시 로직
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("!")
        // 내가'! 입력한 질문, 아직 답하지 않음 상태에서의 로직
        if let inputAccessoryView = answerTextView.inputAccessoryView {
            inputAccessoryView.isHidden = false
        }
//        questionState = .opponentQuestionNotAnswered
          questionState = .opponentQuestionAnsweredHidden
        // 상태 업데이트 후 UI 갱신
        switch questionState {
        case .opponentQuestionNotAnswered:
            // 상대방이 아직 답하지 않은 경우
            UIView.transition(with: tidView, duration: 0.5, options: .transitionFlipFromRight, animations: { [self] in
                // tidView의 하위 뷰 없애
                tidView.subviews.forEach { subview in
                    subview.isHidden = true
                }
                
                // 새로운 UILabel을 생성하여 tidView의 중앙에 추가
                label = UILabel()
                label.text = "아직 입력하지 않았습니다."
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont.systemFont(ofSize: 16)
                label.numberOfLines = 0 // 여러 줄 텍스트 지원
                
                // 레이블의 크기와 위치 tidView의 중앙
                label.frame = CGRect(x: 0, y: 0, width: tidView.frame.width, height: tidView.frame.height)
                label.center = CGPoint(x: tidView.frame.width / 2, y: tidView.frame.height / 2)
                
                // tidView에 레이블 추가
                self.saveButton.isHidden = true
                tidView.addSubview(label)
                
                
            }) { (completed) in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tidViewTapped))
                self.tidView.addGestureRecognizer(tapGesture)
                self.questionState = .myQuestion
            }
            
        case .opponentQuestionAnsweredHidden:
            // 상대방이 이미 답한 경우
            UIView.transition(with: tidView, duration: 0.5, options: .transitionFlipFromRight, animations: { [self] in
                showButtonmaker()
                self.saveButton.isHidden = true
                self.viewAnswerButton?.isHidden = false
                
                
            }) { (completed) in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tidViewTapped))
                self.tidView.addGestureRecognizer(tapGesture)
                self.questionState = .opponentQuestionAnsweredHidden
            }
            
        default:
            break
        }
    }

    func showButtonmaker() {
        // tidView가 nil이 아닌 경우에만 실행
        guard let tidView = tidView else {
            return
        }
        
        // tidView의 하위 뷰 없애기
        tidView.subviews.forEach { subview in
            subview.isHidden = true
        }

        // 새로운 UIButton을 생성하여 tidView의 중앙에 추가
        viewAnswerButton = UIButton()
        viewAnswerButton.setTitle("보기", for: .normal)
        viewAnswerButton.setTitleColor(.black, for: .normal)
        viewAnswerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        viewAnswerButton.titleLabel?.numberOfLines = 0
        viewAnswerButton.titleLabel?.textAlignment = .center

        // 텍스트에 맞게 버튼 크기 설정
        let textSize = viewAnswerButton.titleLabel?.sizeThatFits(CGSize(width: tidView.frame.width, height: tidView.frame.height))
        let buttonWidth = min(tidView.frame.width, textSize?.width ?? 0)
        let buttonHeight = min(tidView.frame.height, textSize?.height ?? 0)
        viewAnswerButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)

        // 버튼의 중앙을 tidView의 중앙으로 설정
        viewAnswerButton.center = CGPoint(x: tidView.frame.width / 2, y: tidView.frame.height / 2)

        // 터치시에 해당 함수
        viewAnswerButton.addTarget(self, action: #selector(viewAnswerButtonTapped), for: .touchUpInside)

        // tidView에 버튼 추가
        tidView.addSubview(viewAnswerButton)
    }


    @objc func viewAnswerButtonTapped() {
        
        print("!")
        questionState = .opponentQuestionAnsweredVisible
        
        
        
    }

}

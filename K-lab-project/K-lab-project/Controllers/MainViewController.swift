//
//  MainViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/30.
//

import UIKit
import SwiftUI

<<<<<<< HEAD
class MainViewController: UIViewController, UITextViewDelegate {
    
    // Country Label
    @IBOutlet weak var loverCountry: UILabel!
    @IBOutlet weak var myCountry: UILabel!
    
    //Time Label
    @IBOutlet weak var loverTime: UILabel!
    @IBOutlet weak var myTime: UILabel!
    
    
    @IBOutlet weak var mainTIDLabel: UILabel!
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBOutlet weak var loverAnswerLabel: UILabel!
    
    
    @IBOutlet weak var tidView: UIView!
    //상태 : Models에 있음
    var questionState: QuestionState = .myQuestion
    //아직 입력하지 않았다는 레이블
    var label: UILabel!
    // 보기 버튼
    @IBOutlet weak var viewAnswerButton: UIButton!
    
=======
class MainViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var newsArray: [News] = [
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000"),
        News(newsImage:UIImage(systemName: "newspaper"),newsHeadLine: "0000000", newsMainText: "0000000000")
    ]

    
    
    
    @IBOutlet weak var mainWeather_tableView: UITableView!
    @IBOutlet weak var mainNews_tableView: UITableView!
>>>>>>> main
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
<<<<<<< HEAD
        answerTextView.delegate = self
=======
        mainNews_tableView.dataSource = self
        mainNews_tableView.delegate = self
        
        let tapNewsGesture = UITapGestureRecognizer(target: self, action: #selector(didNewsTapView(_:)))
        
        let tapWeatherGesture = UITapGestureRecognizer(target: self, action: #selector(didWeatherTapView(_:)))

        mainNews_tableView.addGestureRecognizer(tapNewsGesture)
        mainWeather_tableView.addGestureRecognizer(tapWeatherGesture)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainNews_tableView.dequeueReusableCell(withIdentifier: "MainNewsTableViewCell", for: indexPath) as! MainNewsTableViewCell
>>>>>>> main
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))

        // Done 버튼을 오른쪽에 배치하기 위해 flexibleSpace를 추가
        toolbar.items = [flexibleSpace, doneButton]

        answerTextView.inputAccessoryView = toolbar
        
        //UI set
        updateUI()
        
<<<<<<< HEAD
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
        // 특정 조건을 만족하는 경우에만 함수 실행
        if shouldActivateTidViewTapped() {
            UIView.transition(with: tidView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.tidView.subviews.forEach { subview in
                    subview.isHidden = false
                }
                self.viewAnswerButton.isHidden = true
                self.saveButton.isHidden = false
                
                // 입력하지 않았다는 label 제거
                self.label?.removeFromSuperview()
            }, completion: { (completed) in
                self.questionState = .myQuestion
                if let tapGesture = self.tidView.gestureRecognizers?.first {
                    self.tidView.removeGestureRecognizer(tapGesture)
                }
                
                let newTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tidViewTapped))
                self.tidView.addGestureRecognizer(newTapGesture)
            })
        }
    }

    // 조건 체크 (tidtapped에 사용)
    func shouldActivateTidViewTapped() -> Bool {
        return questionState == .opponentQuestionNotAnswered
    }

    
    func updateUI() {
        
        //1초마다 타이머 업데이트
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        switch questionState {
        case .myQuestion:
            // 내가 입력한 질문, 아직 답하지 않음
            answerTextView.isHidden = false
            saveButton.isHidden = false
            viewAnswerButton.isHidden = true
            loverAnswerLabel.isHidden = true
            self.mainTIDLabel.text = "TID"
            
            // 여기에서 inputAccessoryView를 사용하기 전에 nil 체크 -> 오류 왜 뜨니
            if let inputAccessoryView = answerTextView.inputAccessoryView {
                inputAccessoryView.isHidden = false
            }
        case .opponentQuestionNotAnswered:
            // 상대방이 입력한 질문, 아직 답하지 않음
            answerTextView.isHidden = false
            saveButton.isHidden = true
            loverAnswerLabel.isHidden = true
        case .opponentQuestionAnsweredHidden:
            // 상대방이 입력한 질문, 답이 있음 (답이 숨겨진 상태)
            saveButton.isHidden = true
            viewAnswerButton.isHidden = true
            loverAnswerLabel.isHidden = true
            
        case .opponentQuestionAnsweredVisible:
            // 상대방이 입력한 질문, 답이 있음 (답이 표시된 상태)
            answerTextView.isHidden = true
            saveButton.isHidden = true
            loverAnswerLabel.isHidden = false
            self.mainTIDLabel.text = "TLD"
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // 테스트 위한 상태 변경
//      questionState = .opponentQuestionNotAnswered
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
                label.numberOfLines = 0
                
                // 레이블의 크기와 위치 tidView의 중앙
                label.frame = CGRect(x: 0, y: 0, width: tidView.frame.width, height: tidView.frame.height)
                label.center = CGPoint(x: tidView.frame.width / 2, y: tidView.frame.height / 2)
                
                // tidView에 레이블 추가
                self.saveButton.isHidden = true
                tidView.addSubview(label)
                
                
            }) { (completed) in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tidViewTapped))
                self.tidView.addGestureRecognizer(tapGesture)
            }
            
        case .opponentQuestionAnsweredHidden:
            // 상대방이 이미 답한 경우
            UIView.transition(with: tidView, duration: 0.5, options: .transitionFlipFromRight, animations: { [self] in
                
                tidView.subviews.forEach { subview in
                    subview.isHidden = true
                }
                self.saveButton.isHidden = true
                self.viewAnswerButton.isHidden = false
                
                
            }) { (completed) in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tidViewTapped))
                self.tidView.addGestureRecognizer(tapGesture)
            }
            
        default:
            break
        }
    }


    
    @IBAction func viewAnswerButtonTapped(_ sender: Any) {
        print("!")
            
            UIView.transition(with: tidView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.tidView.subviews.forEach { subview in
                    subview.isHidden = false
                }
                
                self.questionLabel.isHidden = true
                self.answerTextView.isHidden = true
                self.mainTIDLabel.text = "TLD"
                self.loverAnswerLabel.isHidden = false
                
                // 버튼 숨김
                self.viewAnswerButton.isHidden = true
                
            }, completion: nil)
        
        
    }
    deinit {
            // 뷰가 해제될 때 Observer 해제
            NotificationCenter.default.removeObserver(self)
        }

        // 키보드가 나타날 때 실행되는 함수
    @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                // 키보드의 높이를 통해 화면을 조절
                self.view.frame.origin.y = -(keyboardSize.height)+40
            }
        }
        // 키보드가 사라질 때 실행되는 함수
        @objc func keyboardWillHide(_ notification: Notification) {
            self.view.frame.origin.y = 0
        }
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }

    
=======
        
        
        return cell
    }
    
    @objc func didNewsTapView(_ sender: UITapGestureRecognizer) {
        
        // 테이블 뷰가 탭되었을 때 실행되는 코드
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "NewsViewController")
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    

    @objc private func didWeatherTapView(_ sender: UITapGestureRecognizer) {
        let hostingController = WeatherViewHostingController(rootView: WeatherViewController())
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }

>>>>>>> main
}

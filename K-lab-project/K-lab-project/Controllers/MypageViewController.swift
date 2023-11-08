//
//  MypageViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 10/30/23.
//

import UIKit

class MypageViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet var mypage_stackViewCells: [UIStackView]!
    @IBOutlet var myPage_textField: [UITextField]!
    @IBOutlet weak var myPageImageView: UIImageView!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var birthLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var textFields: [UITextField] = []
    var labels: [UILabel] = []
    
    //edit 상태
    var editStatus:Bool = false
    
    //Picker
    let datePicker = UIDatePicker()
    let countryPicker = UIPickerView()
    let birthPicker = UIDatePicker()
    let country = ["Korea", "Netherlands","USA", "Japan","China"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        textFields = [userNameTextField,countryTextField,dayTextField,birthTextField]
        labels = [userNameLabel,countryLabel,dayLabel,birthLabel]
        userNameTextField.isHidden = true
        
        //Country Picker
        setupCountryPickerToolBar()
        setupCountryPicker()
        
        //Date Picker
        setupDayPickerToolBar()
        setupDatePicker()
        //Birth Picker
        setupBirthPickerToolBar()
        setupBirthPicker()

    }
    func setUI(){
        //유저의 이미지
        myPageImageView.layer.cornerRadius =  myPageImageView.frame.width / 2
        myPageImageView.layer.borderWidth = 2
        myPageImageView.layer.borderColor = UIColor.gray.cgColor
        
        //
        for i in myPage_textField {
            i.borderStyle = .none
        }
        for i in mypage_stackViewCells{
            i.layer.cornerRadius = 8;
            i.layer.masksToBounds = true;
        }
        
        
        editButton.layer.cornerRadius = 8;
        editButton.layer.masksToBounds = true;
        
        deleteButton.layer.cornerRadius = 8;
        deleteButton.layer.masksToBounds = true;
    }
    
    
    // edit 버튼을 눌렀다면
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if editStatus {
                    for (textField, label) in zip(textFields, labels) {
                        label.text = textField.text
                        label.isHidden = false
                        textField.isHidden = true
                    }
                    editButton.setTitle("Edit", for: .normal)
                } else {
                    // 수정중일 경우
                    for (textField, label) in zip(textFields, labels) {
                        textField.text = label.text
                        textField.isHidden = false
                        label.isHidden = true
                    }
                    editButton.setTitle("Save", for: .normal)
                }
                editStatus.toggle()
        
    }
    
    //Country Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return country.count
    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return country[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = country[row]
    }
    
    func setupCountryPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        countryTextField.inputView = pickerView
    }
    func setupCountryPickerToolBar(){
        
        let toolBar = UIToolbar()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandeler))

        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        countryTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneCountryButtonHandeler(_ sender: UIBarButtonItem) {
        countryTextField.text = dateFormat(date: datePicker.date)
        // 키보드 내리기
        countryTextField.resignFirstResponder()
    }
    
    //DayPicker
    private func setupDatePicker() {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            // 언어선택
            //datePicker.locale = Locale(identifier: "ko-KR")
            // 값이 변할 때마다 동작
            datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        dayTextField.inputView = datePicker
            // textField에 오늘 날짜로 표시되게 설정
        dayTextField.text = ""
        }
        
        // 값이 변할 때 마다 동작
        @objc func dateChange(_ sender: UIDatePicker) {
            // 값이 변하면 UIDatePicker에서 날자를 받아와 형식을 변형해서 textField로
            dayTextField.text = dateFormat(date: sender.date)
        }
        
        // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
        private func dateFormat(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy / MM / dd"
            
            return formatter.string(from: date)
        }
        //DONE toolbar
        private func setupDayPickerToolBar() {
            
            let toolBar = UIToolbar()

            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandeler))

            toolBar.items = [flexibleSpace, doneButton]
            toolBar.sizeToFit()
            dayTextField.inputAccessoryView = toolBar
        }
        
        @objc func doneButtonHandeler(_ sender: UIBarButtonItem) {
            dayTextField.text = dateFormat(date: datePicker.date)
            // 키보드 내리기
            dayTextField.resignFirstResponder()
        }
    
    //BirthPicker
    private func setupBirthPicker() {
            birthPicker.datePickerMode = .date
            birthPicker.preferredDatePickerStyle = .wheels
            // 언어선택
            //datePicker.locale = Locale(identifier: "ko-KR")
            // 값이 변할 때마다 동작
        birthPicker.addTarget(self, action: #selector(birthChange), for: .valueChanged)
        birthTextField.inputView = birthPicker
            // textField에 오늘 날짜로 표시되게 설정
        birthTextField.text = ""
        }
        
        // 값이 변할 때 마다 동작
        @objc func birthChange(_ sender: UIDatePicker) {
            // 값이 변하면 UIDatePicker에서 날자를 받아와 형식을 변형해서 textField로
            birthTextField.text = birthFormat(date: sender.date)
        }
        
        // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
        private func birthFormat(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy / MM / dd"
            
            return formatter.string(from: date)
        }
        //DONE toolbar
        private func setupBirthPickerToolBar() {
            
            let toolBar = UIToolbar()

            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBirthButtonHandeler))

            toolBar.items = [flexibleSpace, doneButton]
            toolBar.sizeToFit()
            birthTextField.inputAccessoryView = toolBar
        }
        
        @objc func doneBirthButtonHandeler(_ sender: UIBarButtonItem) {
            birthTextField.text = dateFormat(date: birthPicker.date)
            // 키보드 내리기
            birthTextField.resignFirstResponder()
        }
    
}

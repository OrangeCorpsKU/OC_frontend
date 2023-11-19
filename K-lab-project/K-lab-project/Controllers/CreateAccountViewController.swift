//
//  CreateAccountViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 2023/10/29.
//

import UIKit

class CreateAccountViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var UserIDTextField: UITextField!
    @IBOutlet weak var CountryTextField: UITextField!
    @IBOutlet weak var DateTextField: UITextField!
    @IBOutlet weak var UserImageView: UIImageView!
    
    
    let datePicker = UIDatePicker()
    let countryPicker = UIPickerView()
    let country = ["Korea", "Netherlands","USA", "Japan","China"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Country Picker
        setupCountryPickerToolBar()
        setupCountryPicker()
        
        //Date Picker
        setupDatePickerToolBar()
        setupDatePicker()
        
        //set UI
        setupUI()

    }
    
    private func setupUI(){
        SignUpButton.layer.cornerRadius = 8
        UserIDTextField.placeholder = "USERNAME"
        CountryTextField.placeholder = "COUNTRY"
        DateTextField.placeholder = "Date of Birth"
        
        UserImageView.layer.cornerRadius =  UserImageView.frame.width / 2
                //테두리 굵기
        UserImageView.layer.borderWidth = 2
                //테두리 색상
        UserImageView.layer.borderColor = UIColor.gray.cgColor
        
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
        CountryTextField.text = country[row]
    }
    
    func setupCountryPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        CountryTextField.inputView = pickerView
    }
    func setupCountryPickerToolBar(){
        
        let toolBar = UIToolbar()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandeler))

        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        CountryTextField.inputAccessoryView = toolBar
    }
    @objc func doneCountryButtonHandeler(_ sender: UIBarButtonItem) {
        CountryTextField.text = dateFormat(date: datePicker.date)
        // 키보드 내리기
        CountryTextField.resignFirstResponder()
    }
    
    
    
    //DatePicker
    private func setupDatePicker() {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            // 언어선택
            //datePicker.locale = Locale(identifier: "ko-KR")
            // 값이 변할 때마다 동작
            datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        DateTextField.inputView = datePicker
            // textField에 오늘 날짜로 표시되게 설정
        DateTextField.text = ""
        }
        
        // 값이 변할 때 마다 동작
        @objc func dateChange(_ sender: UIDatePicker) {
            // 값이 변하면 UIDatePicker에서 날자를 받아와 형식을 변형해서 textField로
            DateTextField.text = dateFormat(date: sender.date)
        }
        
        // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
        private func dateFormat(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy / MM / dd"
            
            return formatter.string(from: date)
        }
        //DONE toolbar
        private func setupDatePickerToolBar() {
            
            let toolBar = UIToolbar()

            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandeler))

            toolBar.items = [flexibleSpace, doneButton]
            toolBar.sizeToFit()
            DateTextField.inputAccessoryView = toolBar
        }
        
        @objc func doneButtonHandeler(_ sender: UIBarButtonItem) {
            DateTextField.text = dateFormat(date: datePicker.date)
            // 키보드 내리기
            DateTextField.resignFirstResponder()
        }
        

    
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
                dismiss(animated: true)
    }
    
    
    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "CoupleRegisterViewController")
                vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
                vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
                self.present(vcName!, animated: true, completion: nil)
    }
    
    
    

}

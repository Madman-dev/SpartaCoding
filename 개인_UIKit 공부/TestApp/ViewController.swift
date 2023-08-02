//
//  ViewController.swift
//  TestApp
//
//  Created by Jack Lee on 2023/07/31.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - UIKit Framework강의
    //    @IBOutlet weak var firstButton: UIButton!
//    @IBOutlet weak var newButton: UIButton!
    
    /// UIScrollView
//    var scrollView: UIScrollView! // 이 친구는 변수인가...? 따로 생성하는게 아니다?
//    var imageView: UIImageView!
    
    /// UIPickerView
//    let pickerView = UIPickerView()
//    let data = [["1","2","3","4","5","6","7","8","9","10","11","12"],["1월","2월","3월"]]//["1993년"]]
//    [1,2,3,4,5,6,7,8,9,10,11,12]
    
    /// UITableView
    let data = ["apple", "Banana", "Cherry", "Watermelon", "Korean Melon"]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - UIKit Framework강의(
        /// textLabel
        //        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 300, height: 50))
//        label.text = "안녕하세요"
//        label.textColor = .red
//        label.font = .systemFont(ofSize: 20)
//        label.textAlignment = .center
//        self.view.addSubview(label) // 새로 생성한 label을 view 위로 올린다~
        
        /// UIImageView
//        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        let image = UIImage(systemName: "folder.fill")
///        let image2 = UIImage(named: "folder.fill") >> 🔥systemNamed로 접근하지 않으면 안나오는 구만~ 이 친구는 asset에서 호출할 때만!
//        imageView.image = image
//        imageView.contentMode = .scaleAspectFit
//        self.view.addSubview(imageView)
        
        /// UITextField
//        let textField = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
//        textField.placeholder = "입력 바람미다"
//        self.view.addSubview(textField)
        
        /// creating button programmatically
//        let newlyButton = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
//        newlyButton.setTitle("버튼임미다", for: .normal)
//        newlyButton.backgroundColor = .red
//        newlyButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        self.view.addSubview(newlyButton)
        
        
        /// UISwitch
//        let switchButton = UISwitch(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        switchButton.onTintColor = .brown
//        switchButton.isOn = true
//        switchButton.tintColor = .systemPink
//        switchButton.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
//        self.view.addSubview(switchButton)
        
        ///UISlider
//        let newSlider = UISlider(frame: CGRect(x: 100, y: 300, width: 150, height: 100))
//        newSlider.maximumValue = 0.0
//        newSlider.maximumValue = 100.0
//        newSlider.setValue(50.0, animated: true)
//        newSlider.tintColor = .brown
//        newSlider.thumbTintColor = .black
//        newSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)     // @objc func로 호출을 하게 되면 파라미터 속에 전달 받는 sender의 값이 없기 때문에 value를 받을 수 없어 보임 -> 진짜인가?
//        self.view.addSubview(newSlider)
        
        /// UISegmentControl
        // 이친구는 따로 하지 않았음!
        
        /// UIScrollView
//        scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: 300), size: CGSize(width: view.bounds.width, height: 300)))
        // view.bounds를 사용하기 위해 변수를 선언 이후 값을 설정하셨다!
        
//        scrollView.delegate = self  // 프로토콜이기에 채택을 시킨다-
//        scrollView.backgroundColor = .black
//
//        let image = UIImage(systemName: "folder.fill") // 어떤 이미지를 쓸지 선택 > 위치는 좌측 상단으로 고정인건가?
//        imageView = UIImageView(image: image) // 선택한 이미지를 이미지 뷰 안에 설정
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
//
//        scrollView.addSubview(imageView) // 왜 이걸 여기에 더한거지? > scrollView는 그냥 영역을 의미한다. 안에 어떤 것이 들어있을지를 설정해줘야 하는데, 이게 addSubView를 통해 할 수 있다는 점~
//        scrollView.contentSize = CGSize(width: view.bounds.width * 2, height: 300 * 2)  // 이게 어렵네
//        scrollView.minimumZoomScale = 0.5
//        scrollView.maximumZoomScale = 2.0
//        self.view.addSubview(scrollView)
        
        
        /// PickerView
//        pickerView.frame = CGRect(x: 100, y: 100, width: 200, height: 900)
//        self.view.addSubview(pickerView)
//        pickerView.dataSource = self
//        pickerView.delegate = self
        
        
        /// UITableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)


        
        //MARK: - IB강의 - background 담당 View 객체 생성
        // let myView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        // myView라는 객체를 만드는데, UIView의 객체로, frame이라는 conven init을 활용 - CGRect 타입의 Frame에서 또 init을 하는데, 초기 높이 넓이의 값은 100과 100이다~
        
        
        //MARK: - IB강의 - 컬러 변경 시도
        //        myView.backgroundColor = UIColor.red
        //        self.view.addSubview(myView) // 계층적으로 내가 만든 view 객체를 mainView에 속할 수 있도록, 올릴 수 있도록 해야 보이기 시작한다. -> Different from changing the backgroundColor of view.backgroundColor
        
        
        //MARK: - IB강의 - myView 객체로 값 적용
        // myView.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        // -> x와 y 좌표는 좌측 상단을 기준으로 잡고 있기 때문에 50, 50 차이가 발생하는 것이고 width Size는 200으로 override 되는 것으로 보여진다.
        // myView.frame = CGRect(x: 100, y: 50, width: 500, height: 500) -> 이런식으로 계속 덮는다~
        
        // print("view Did Load")
        
        
        //MARK: - IB강의 - 네비게이션 컨트롤러 (Container View Controller 예시  -> 안되네 근데...)
        //        let viewControllerOne = UIViewController()
        //        viewControllerOne.title = "첫번째 View Controller"
        //        navigationController?.setViewControllers([viewControllerOne], animated: false)
        //
        //        addChild(navigationController!)
        //        view.addSubview(navigationController!.view)
        //        navigationController?.didMove(toParent: self)
        //
        //        navigationController!.view.frame = view.bounds
        //
        //        let button = UIButton(type: .system)
        //        button.setTitle("Push View Controller", for: .normal)
        //        button.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        //        navigationController?.navigationBar.addSubview(button)
        
        //MARK: - IB강의 - navigationController push pop 구현
        //        let button = UIButton(type: .system)
        //        button.setTitle("Push View Controller", for: .normal)
        //        button.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        //        button.frame = CGRect(x: 200, y: 200, width: 200, height: 100)
        //        self.view.addSubview(button)
        
        
        //MARK: - IB강의 - UserInterface
        //        firstButton.setTitle("변경이 안되나?", for: .normal)
        //            self.firstButton.titleLabel?.textColor = .blue > 안됨
        //        firstButton.setTitleColor(.brown, for: .normal) > 됨
        //        DispatchQueue.main.async { >> mainThread로 지정을 하면 됨
        //            self.firstButton.titleLabel?.textColor = .blue
        //        }
    }
    
    //    @IBAction func touchButton(_ sender: Any) {
    //        print("버튼이 눌렸습니다.")
    //        self.view.backgroundColor = .red
    //    }
    
    //    @objc func pushViewController() {
    //        let newViewController = UIViewController()
    //        newViewController.title = "새로운 View Controller"
    //        newViewController.view.backgroundColor = .blue
    //        navigationController?.pushViewController(newViewController, animated: true)
    //    }
//    @objc func buttonPressed() {
//        print("버튼이 눌렸을까용?")
//    }
    
//    @IBAction func buttonIsTapped(_ sender: UIButton) {
//        print("버튼이 눌렸어용!")
//    }
    
//    @objc func switchToggled() {
//        print("스위치가 바뀌었습니다.")
//    }
//    @IBAction func printSlider(_ sender: UISlider) {
//        print("값이 \(sender.value)만큼 바뀌었습니다.")
//    }
    
//    @objc func sliderChanged() {
//        print("값이 바뀝니다.")
//    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }   // scrollView의 줌인 줌아웃 적용하는 코드! ⭐️ 특별히 줌인 행동을 적용하고 싶은 View를 따로 지정해야하는건가?
    
//    /// data에 담긴 값 갯수 만큼 wheel에 빈 공간을 만드는 역할
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return data[component].count //data.count (하나의 값만 활용할 경우)
//        // UIPickerDataSource에 담긴 값만큼 보여주어야 하니 data의 갯수만큼이다. -> 캘린더라고 치면 월[1~12] 값을 담고 있는 변수에 접근하고 있는것과 동일해 보인다! -> 월,일 같이 2개의 값을 활용하고 싶고 - 2개의 배열을 하나의 배열 속에 담을 경우, data.count는 값이 2개로만 확인된다. 따라서 data 값 속의 [component]를 접속하고 .count를 세야 모든 값이 확인 가능하다. >>> data[component]면 근데 하나의 배열 갯수만 확인되어야 하는거 아닌가...?🙋🏻‍♂️ (확인만) > 🔥 subscript로 이미 들어가 있는 값이기에 월/ 일을 만들고 싶은 경우 data.count는 2를 출력한다. data[component].count를 해야 모든 값을 확인할 수 있다.
//    }
//
//    /// 휠을 몇개 만들 건지 정하는 역할
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return data.count
//    }   // 🔥 이 부분 이해 안 된다! 뭐하는 친구지? > 내가 picker로 활용하고 싶은 친구들을 정리한 거네! 2이면 스크롤 휠이 2개 생기는 거구나! 지금은 배열속에 2개의 값을 담고 있으니 data.count를 했을 때 2개가 나오는거구나
//
//    /// 만들어진 빈 공간에 값을 하나씩 넣는 역할? 🙋🏻‍♂️(확인만)
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        // print(type(of: data)) -> 현재 data 값이 배열 속의 String 배열이기 때문에 String으로 리턴을 하기 위해서, subscript를 두번 써야 하는 것
//        return data[component][row] + "테스트" // 이 친구의 역할이 뭘까... > 🔥 렌더링 시 어떤 값을 사용자에게 보여질 것인지 활용하는 함수
//        // > 리턴하는 값이 String이기에 data 값 또한 String 배열이어야 한다. Int로 하면 안된다는 점 🙋🏻‍♂️ 꼭 String 값이어야 하는건가? 변경은 안되려나? (변경 가능 여부 체크) > 불가능
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedValue = data[component][row]
//        print(data[component])  // 어떻게 알아서 확인할 수 있지??? ⭐️
//        print("선택", selectedValue)
//    }   // 이 친구는 선택 됐을 때 행동을 출력하는 친구네 (print) 어떤 값이 선택됐다.
    
    /// 아래에서 DataSource의 값들을 하나의 셀로 표현을 하고 있다. cell은 기본적으로 구현이 필요
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row] // 우리가 생성한 cell의 텍스트를 데이터 값에 접근해서
        return cell
    }
    /// 사용되는 section에 대한 row의 갯수를 확인하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    /// 선택하는 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택된 값", data[indexPath.row])
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {    //상속받은 UIViewController이 가지고 있는 함수를 override하는 개념~
        super.viewWillAppear(animated)
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view Did Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view Did disappear")
    }
    
}

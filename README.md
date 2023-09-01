# SpartaCoding

<details closed>
<summary> 투두 앱 💪🏻</summary>

## TodoApp
### 구현 기능
- 할일 목록 추가
- 할일 목록 삭제
- 할일 목록 수정
- 완료 페이지 URL 이미지 호출
- 완료 페이지
- userDefault 대신 CoreData로 데이터 호출 구현

### 미구현 기능
- *할일 완료 처리 X

## MVC 패턴
### Model
- Todo+CoreDataClass
- Todo+CoreData Properties
- Errors
- Categories

- 모델은 앱에서 구현/처리해야할 데이터가 무엇인지 정의합니다.
  해당 모델에 속해 있는 데이터의 상태가 변하면 모델에서 뷰에게 상태 변화를 알리고 controller에서 업데이트를 진행합니다.
- 현재 앱 내에서 처리할 데이터 구조를 정의한 파일로, Errors, Categories 및 CoreData 관련 model이 정의되어 있습니다.
- 코어 데이터를 사용하게 되면서 NSManagedObject를 처리할 CoreData를 위한 모델을 구성했습니다.
- CoreData에는 enum을 저장하는 방식이 없어 데이터 호출 당시 오류가 많이 발생 - 더미 데이터를 처리하고자 Categories라는 모델을 따로 설정했습니다. 

### Views
- TodoViewCell
- FinishedCell
- SectionViewCell
  
- 앱에서 그리는 화면을 정의하며 표시한 데이터는 모델에서 공유 받습니다.
- 메인 테이블 뷰와 완료된 데이터를 처리하는 테이블뷰가 있으며, 카테고리를 정리할 수 있도록 collectionView가 있기에
셀 별로 데이터를 입력 받고 처리할 수 있도록 정리하였습니다.


### Controller
- 사용자의 입력을 처리하는 역할로, 받은 응답 신호로 뷰 또는 모델을 업데이트를 담당합니다.
- ViewController, FinishedController로 정리하였습니다.



</details>

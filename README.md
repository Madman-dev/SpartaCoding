# SpartaCoding

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
- 모델은 앱에서 구현/처리해야할 데이터가 무엇인지 정의합니다.
  해당 모델에 속해 있는 데이터의 상태가 변하면 모델에서 뷰에게 상태 변화를 알리고 controller에서 업데이트를 진행합니다.
- 현재 앱 내에서 처리할 데이터 구조를 정의한 파일로, Errors, Categories 및 CoreData 관련 model이 정의되어 있습니다.

### Views
- 앱에서 그리는 화면을 정의하며 표시한 데이터는 모델에서 공유 받습니다.
- TodoViewCell, FinishedCell, SectionViewCell로 테이블뷰와 컬렉션 뷰의 셀 정보를 담고 있습니다.

### Controller
- 사용자의 입력을 처리하는 역할로, 받은 응답 신호로 뷰 또는 모델을 업데이트를 담당합니다.
- ViewController, FinishedController로 정리하였습니다.

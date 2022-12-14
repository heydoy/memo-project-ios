# 🌱 MEMO 

## 🍎 개선내용

2022.10.24 > 기존 테이블 뷰를 Compositional Layout + Diffable Datasource로 변경

<br>

## 📱 화면과 기능, 구현방식

### 🤗 웰컴 스크린 
 `UserDefaults`에서 `Bool`타입 변수를 이용해 앱 첫실행여부를 체크하고 처음일 경우에만 보여줍니다.
| - 환영 팝업 | 
| --- |
| ![Simulator Screen Recording - iPhone 11 - 2022-09-05 at 01 54 20](https://user-images.githubusercontent.com/51395335/188351455-41f40215-f24a-40d3-bc50-5bbaa48b51d0.gif) |

<br>

### 🖊 메모 작성하기 
1. 메모 작성 시 첫번째 개행문자를 발견하기 전까지는 타이틀, 이후는 콘텐츠로 저장합니다. 완료버튼을 누르거나 뒤로가기를 누르면 저장됩니다.
2. 메모 작성 시 키보드와 바 버튼이 모두 보입니다. 
2. 내용이 없으면 저장하지 않습니다. 
3. 공유 버튼을 누르면 작성된 내용이 `Activity View` 를 통해 공유됩니다. (내용이 없을 경우 공유가 되지 않습니다.)

| - 메모 작성하기   |  - 내용이 없으면 저장하지 않기    | - 메모 공유하기 |
|---|---|---|
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 21 04](https://user-images.githubusercontent.com/51395335/188488775-0cb51536-fa66-4f39-98bb-7b56aab3851e.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-05 at 16 13 27](https://user-images.githubusercontent.com/51395335/188389038-5925d2d5-3b09-4d33-9631-e8d0d94378e1.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-05 at 16 13 56](https://user-images.githubusercontent.com/51395335/188389183-a51f0094-e4ee-4b07-bc93-87400655273e.gif) |

<br>

### 📝 메모 수정하기
1. 리스트에서 셀을 선택하면 수정하기로 넘어가고, 키보드와 바 버튼이 보이지 않습니다. 
2. 수정창에서 한 번 더 탭하면 키보드와 바 버튼이 보입니다. 

<br>

| -  메모 수정 | 
| --- |
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 26 30](https://user-images.githubusercontent.com/51395335/188489244-5c807f17-1f5c-487e-a4d8-193ab9816389.gif) |

### 🧩 메모 리스트 
1. 오늘 중에 작성된 메모는 시간, 주중에 작성된 메모는 요일, 그 외에는 년월입이 입력되도록 합니다. 
2. 메모의 개수는 바로 반영되서 위에 뜨게 됩니다. 만약 1천개가 넘을 경우 세자리수마다 쉼표가 표시됩니다. 
3. `leadingSwipeAction`으로 메모를 고정할 수 있습니다.
4. `trailingSwipeAction`으로 메모를 삭제할 수 있습니다. 

<br>

| - 메모 목록 |  -  스와이프액션 - 핀 고정   | - 스와이프액션 - 삭제|
|---|---|---|
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 36 14](https://user-images.githubusercontent.com/51395335/188490251-824f7249-d15d-4706-b99c-6ae236a12365.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 33 40](https://user-images.githubusercontent.com/51395335/188490025-7e67b282-492d-432e-9e54-8e3fb55e7da1.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 34 56](https://user-images.githubusercontent.com/51395335/188490145-2f89af7c-a0c2-4622-9c17-dee04adac403.gif)|


### 🔍 검색
1. 검색어에 일치하는 메모를 실시간으로 보여줍니다.
2. 일치한 문자열은 색깔이 다르게 표시됩니다. 
3. 검색창에서 검색결과를 클릭해도 메모 수정하기 화면을 볼 수 있습니다.

| - 검색화면 | 
| --- |
| ![Simulator Screen Recording - iPhone 11 - 2022-09-06 at 01 38 52](https://user-images.githubusercontent.com/51395335/188490539-75b44e2b-4b2b-498e-bc8d-7f785e5dd613.gif) |


<br>


### 💭 돌아보며
평소에는 커밋이나 문서, 이슈에 전혀 신경쓰지 않았는데, 이번에는 최대한 과정과 코드와 커밋의 단위를 보기 좋게 만들고 싶다는 생각으로 프로젝트를 진행했습니다.
미리 요구사항을 이슈로 정리하고 커밋을 잘개 쪼개고, 이슈 템플릿과 PR 템플릿을 만들고 커밋 메시지에도 신경을 쓰고, 폴더링과 주석, 구현하면서도 최대한 배운 개념을 활용해보자고 생각했는데요. 
소소한 아쉬움은 차치하고서라도 메모 프로젝트 시작 직전에 배운 `Observable` 그리고 적용해보고 싶었던 `DiffableDataSource`와 `Compositional Layout`을 써보지 못해 큰 아쉬움이 남습니다. 

<br>

---

<br>


### 🛠 개선 방향
0. RX와 MVVM을 이용해 개선하기 
1. 섹션에 너무 의존하는 부분: 검색중이 아닐 때에는 아예 섹션 0을 고정메모 영역으로 잡아두었기 때문에, 고정메모가 없을 경우 위에 빈 공간이 좀 더 생긴다. 다른 곳에서도 섹션 0을 기준점으로 잡아두었는데, 이걸 데이터 중심으로 바꿔야할 것 같다. 
2. 검색 쿼리와 적용되는 문자열을 레이블에 바로 적용할 수 있도록 `UILabel`에 `extension`으로 해두었는데, 오히려 범용적으로 사용하기가 어렵게 되었다. `String` 에 `extension`으로 따로 만들어서 Attributed String을 받아오는 형태로 개선하고 싶다. 

<br>

### 💦 실수
1. `해결함` 프로토콜을 이용하여 값을 역전달 할 때: 자꾸 해당 프로토콜 타입에 VC를 넣을 수 없다는 에러가 떴는데, 알고 보니 `var delegate = protocolName?` 으로 해둔 것... 🤦 못 찾아서 검색으로 3시간 헤맸다. 
2. `해결함` 프로토콜 정의할 때 `AnyObject`를 채택했지만, 약한 참조로 선언하지 않은 부분 -> 약한 참조에 대해 약한 이해가 있었다! 수업으로 배워서 바로 적용했다! 
3. `해결함` 코드로 구현했고 되는 걸 확인했던 것 같은데, 수정 모드에서 바버튼 아이템과 키보드가 제대로 안 없어지는 걸 확인함...🥲 -> 졸려서 코드를 좀 날렸던 것 같다. 제출 후에 수정함 (이슈 #40)

<br>

### 🤷‍♀️ 좀 더 공부하거나 찾아볼 부분
1. `Realm Object`를 다른 화면으로 보내서, 그곳에 선언한 `repository`를 이용하면 동일한 write thread가 아니라서 생기는 에러. 쓰레드에 대한 부분이 아직 어렵다.
2. `Done` - `searchController`를 적용한 상태에서 작성하기를 클릭하면, 시뮬레이터에서는 네비게이션 바가 안의 아이템 크기에 맞춰 자동으로 줄어들지만 왜 디바이스에서는 네비게이션 바가 자동으로 안 줄어들까? -> `prefersLargeTitle`을 `false`로 바꿔주면 된다. thx to @GoForWalk 
3. `inset grouped`에서 섹션 헤더가 셀이 시작하는 위치에 갔으면 좋겠는데 어떻게 옮길지. 
4. ~스와이프 액션 영역이 너무 큰 것 같은데 공간을 줄일 수 있을까?~ <- 셀 높이가 작아서 그렇게 보이는 것. 스와이프액션에서 가로로 차지하는 영역 자체는 똑같다! 
5. `isEditing` 에 대해 좀 더 찾아보기! 

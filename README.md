# BooketList

당신의 책읽기에 관한 모든 것을 기록합니다.

## 💬 프로젝트 소개

### [🔗 앱스토어 바로가기](https://apps.apple.com/kr/app/%EB%B6%81%ED%82%B7%EB%A6%AC%EC%8A%A4%ED%8A%B8-%EB%8B%B9%EC%8B%A0%EC%9D%98-%EB%8F%85%EC%84%9C-%EA%B8%B0%EB%A1%9D%EC%9D%98-%EB%AA%A8%EB%93%A0-%EA%B2%83/id6471903459)

### 작업 기간 및 인원

- 개발: 2023.09.25 ~ 2023.11.12 (8주)
- 출시: 2023.11.13
- 1인 개발(기획, 디자인, iOS 개발)

### 업데이트 내역

| 버전  | 기간       | 업데이트 내용                                                                                                                      |
| ----- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| 1.1.1 | 2023.12.21 | - [feature] 노트의 내용을 Text Scan으로 작성할 수 있도록 함<br>- [bug fix] 노트에 연관 페이지 값으로 음수가 들어가지 못하도록 수정 |

### 기술 스택

- Deployment Target: iOS 15.0
- 개발 환경: Swift 5, Xcode 15.0.1
- 프레임워크: UIKit
- 라이브러리: Realm, SnapKit, KingFisher, Alamofire, Firebase Crashlytics & Messaging
- 아키텍처: MVVM
- 그 외 활용 기술: Codable, Compositional Layout, Diffable DataSource, NWPathMonitor
- open API: 알라딘 API

### 핵심 구현 요소

- Custom Observable class로 MVVM을 적용하여 `ViewController`와 `ViewModel`의 역할을 분리
- Custom Component를 구현하여 코드의 재사용성을 높임
- Alamofire의 URLRequestConvertible으로 Routing 패턴을 적용하여 요청 URL의 엔드포인트를 효율적으로 관리
- NWPathMonitor를 활용하여 기기의 네트워크 통신 상태에 따라 도서 검색 기능의 활성화 여부를 반응형 View로 구성
- Swift의 Generic을 활용하여 타입에 유연하게 동작할 수 있는 코드 작성
- 다크모드 지원

<br>

<details>
<summary>📂 파일 디렉토리 구조</summary>

```bash
├── BooketList
│   ├── NameSpace
│   ├── Scene
│   │   ├── AddBookDetailInfo
│   │   ├── AllRecordsForBook
│   │   ├── EditBookDetailInfo
│   │   ├── EditNote
│   │   ├── MyNote
│   │   ├── MyShelf
│   │   ├── ReadingBoard
│   │   ├── SearchBook
│   │   ├── Settings
│   │   └── WriteNote
│   ├── Cell
│   ├── Product
│   ├── BaseUI
│   ├── Model
│   ├── Database
│   │   ├── FileManager
│   │   └── RealmModel
│   ├── Network
│   │   ├── AladinAPI
│   │   └── Model
│   ├── Extension
│   ├── Protocol
│   └── ko.lproj
└── BooketList.xcodeproj
```

</details>

## 📱 주요 화면 및 기능

> ### Home(Reading Board) 화면
>
> 지금 읽고 있는 책과 읽을 예정인 책을 모아서 보여주는 뷰
>
> 지금 읽고 있는 책에 대한 메모를 간편하게 추가할 수 있습니다.
>
> | 기본 홈 화면                                                                                                | 데이터가 없을 때                                                                                                         | 지금 읽는 중인 책이 없을 때                                                                                                  | 읽을 예정인 책이 없을 때                                                                                                   |
> | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
> | ![홈 화면](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/9810d0d3-4ac1-4259-a01d-97e90574665c) | ![아무데이터도 없을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/f21d9f5e-6514-4dad-b2e5-89ea1fa7d52f) | ![읽을 예정인 책이 없을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/0a8f0977-4f00-47e9-beda-43261a56383e) | ![지금 읽는 책이 없을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/8fa53f60-72ad-4434-84dc-af2179a89d43) |
>
> | 도서 선택 시                                                                                                         | 메모작성 화면                                                                                                      | 페이지 정보 작성                                                                                                               | 라이브 텍스트 기능 사용                                                                                                        |
> | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
> | ![책을 선택했을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/045667f5-8c9f-4100-a92c-e40bbbf69697) | ![메모 작성 화면](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/b107481b-781e-4aa5-ba62-d2b9528c637b) | ![페이지에 대한 정보 작성 시](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/a00493a5-dcdd-47db-a1e1-22c3920a586b) | ![라이브 텍스트 기능 사용 시](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/c7ba3dc8-e17a-4de8-b0c1-78f8d2a2db6b) |

> ### 도서 검색 화면
>
> 알라딘의 Open API를 활용하여 도서를 검색할 수 있습니다.
> | 검색 대기 화면 | 검색 중일 때 | 검색 결과 화면 | 오프라인 상태일 때 |
> | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
> | ![검색 대기 화면](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/432ec4df-c25b-4a83-8f0d-35a13de544d3) | ![검색 결과 기다리는 중](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/85e0999c-eb45-4a23-9434-2f54f990be59) | ![검색결과 화면](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/ed53b00a-0247-4482-a7ce-c6073f95167c) | ![오프라인 상태 시](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/5e270d8f-d838-4530-8959-ef0ebaa7f859) |

> ### 나의 서재 탭
>
> 저장된 모든 책을 세가지 형태로 볼 수 있습니다.
> |저장된 책이 없을 때|그리드 뷰|책꽂이 뷰|리스트 뷰|
> |---|---|---|---|
> |![저장된 도서가 없을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/d6678a63-3013-4c0c-8d17-bd8922bdba6c)|![Grid](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/95c2e984-45c2-4708-a208-51b56a1312c2) | ![Shelf](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/4c831c9a-2e93-47d3-80fb-59cb9581dfad) | ![List](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/edaab05c-eabc-4e10-89c5-7bd95cb57c34) |
>
> | 책 선택 시(책 상세보기)                                                                                         | 책 읽음상태 변경                                                                                                      | 책 정보 수정                                                                                                    |                                                                                                                     |
> | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
> | ![책 상세보기](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/967e5c45-4173-4a1b-b3df-bb49254c358d) | ![책 읽음 상태 변경](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/1e4e3b40-7789-45de-a132-a4858dfb7ff9) | ![책정보 수정](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/d082598b-ffe8-4beb-a6b4-82bd7b6d3489) | ![NoImages_iPhone](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/a87e35f4-63c3-432f-98c9-ce41ff7747b9) |
> |                                                                                                                 |

> ### 나의 노트 탭
>
> 도서마다 작성된 노트를 모두 모아서 볼 수 있고, 검색할 수 있습니다.
> | 기본 화면 | 스와이프 액션 | | |
> | --------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
> | ![나의노트 탭](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/57228eb5-9f06-44ec-bb20-f173d5c0cba3) | ![스와이프 액션](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/d38772eb-e223-4547-9bd7-3f547305169d) | ![NoImages_Simulator](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/5134d8ed-1769-494d-bbd2-137daf3724dc) | ![NoImages_Simulator](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/5134d8ed-1769-494d-bbd2-137daf3724dc) |

> ### 설정 탭
>
> 앱의 정보나 문의 메일을 보낼 수 있는 설정 탭 입니다.
> | 설정 뷰 | 메일 문의 보내기 | | |
> |---|---|---|---|
> |![환경설정](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/ab015b4c-bbec-40d1-8808-b259267c712a)| ![문의메일 보내기](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/f09200a9-1694-47fc-a1b8-add474d3292d)| ![NoImages_iPhone](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/a87e35f4-63c3-432f-98c9-ce41ff7747b9)|![NoImages_iPhone](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/a87e35f4-63c3-432f-98c9-ce41ff7747b9)|

## ✨ 구현 Point!

### 1. 실제 책 사이즈의 비율을 반영한 책꽂이 - Modern Collection View

#### 스크린샷( Home & MyShelf Tab )

| ![Home](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/ea2171b3-13a4-458b-838f-8d43cfda3b35) | ![Grid](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/95c2e984-45c2-4708-a208-51b56a1312c2) | ![Shelf](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/4c831c9a-2e93-47d3-80fb-59cb9581dfad) | ![List](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/edaab05c-eabc-4e10-89c5-7bd95cb57c34) |
| -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |

#### 실제 책의 사이즈를 반영할 수는 없을까?

> 속성 감시자와 `remakeConstraints`를 활용하여 실제 책 크기의 비율을 Cell에 반영하여 현실감 있는 책장 구현! `prepareForReuse`를 통해서 이전 cell에서 사용했던 사이즈 정보가 남지 않도록 지워주는 것까지 알뜰하게 챙겼습니다.

<details>
<summary> 자세한 내용 보기 </summary>

그리드, 책꽂이, 리스트형태로 책을 보여줄 때 책의 실제 크기를 반영해서 책의 높이나 두께와 같은 부분들도 눈에 띄게 보이면 재밌겠다고 생각했습니다. 다행히 제가 사용한 알라딘 API에서는 사이즈를 요청하면 실제 책의 가로, 세로, 높이에 대한 정보를 받아볼 수 있었습니다. 그래서 해당 정보를 활용해서 Cell에 반영해주자고 생각했습니다.

책커버 이미지가 셀을 전체적으로 덮는 BookCoverGridCell에서는 cell에 책의 정보를 받아올 프로퍼티에 속성 감시자를 활용했습니다. 책에 대한 정보가 셀에 전달되면, 커버 이미지를 불러와 imageView에 넣어주고 스냅킷의 `remakeConstraints` 메서드를 활용하여 imageView의 높이를 책의 가로세로 비율에 맞도록 재설정해주었습니다. 또, 오래된 책의 경우 size 정보가 없는 경우도 있었기 때문에 셀의 재사용 매커니즘 상 이전 책의 비율이 남아있지 않도록 하기 위해서 `prepareForReuse`에서 imageView의 크기를 셀의 크기와 동일하게 맞춰주도록 했습니다.

사실 이 작업에서 가장 공과 시간을 많이 들인 부분은 책꽂이처럼 보이도록 하는 `BookShelfCell`입니다. 책꽂이처럼 보이려면, 책의 두께와 높이를 반영해야 했는데, 두께가 충분하지 않으면 책 제목이 안 보이게 될 수도 있었고, Cell이 들어갈 CollectionView의 높이도 어느 정도 고려하지 않으면 높이 차이가 없는 것처럼 보일 수 있었기 때문입니다. 속성 감시자를 활용해서 `remakeConstraints`로 cell의 레이아웃을 다시 잡아주는 동작은 그대로 가져가면서, cell의 minimumWidth와 maximumHeight을 계산해주었습니다. minimumWidth는 view의 layoutMargin과 titleLabel의 lineHeight로 계산해서 책의 두께가 제목을 보여주기에 충분하지 않으면, minimumWidth로 셀의 가로 길이가 반영되게 했습니다. maximumHeight는 셀의 화면에 그려지는 크기로 잡고 standardHeight를 그 수치의 80%로 잡아 API에서 사이즈 정보가 없는 경우에는 지정 높이로 그려지도록 했습니다. 그리고 실제 두께와 높이 비율을 계산해서 view에 사이즈를 반영했습니다.

```swift
private func remakeBackdropViewConstraints(for size: ActualSize?) {
        guard let size else { return }

        let minimumWidth = titleLabel.font.lineHeight + backdropView.layoutMargins.left + backdropView.layoutMargins.right
        let maximumHeight = bounds.height
        let standardHeight = maximumHeight * 0.8

        let width = size.depth
        let height = size.height
        let heightRatio = standardHeight / height

        let cellWidth = width < minimumWidth ? minimumWidth : width
        let cellHeight = height == 0 ? standardHeight : maximumHeight * heightRatio

        backdropView.snp.remakeConstraints { make in
            make.width.equalTo(cellWidth)
            make.height.equalTo(cellHeight)
            make.top.greaterThanOrEqualToSuperview()
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
```

</details>

### 2. font의 사이즈에 따라 자동으로 높이가 계산되는 CustomTextField - instrinctContentSize

#### 스크린샷

![CustomTextField](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/5fb6786b-6668-477a-a490-608730672d63)

#### 마음에 드는 라이브러리가 없다? 그럼 직접 구현하면 되지!!

> 반응형 TextField! 근데 이제 폰트에 따라 스스로 높이를 계산하는...
>
> `intrinsicContentSize`를 오버라이드 하여 textField에 설정된 font의 height에 따라 TextField의 높이가 계산되도록 구현하였습니다.

<details>
<summary> 자세한 내용 보기 </summary>

View를 디자인할 때, 활성화 상태나 입력 여부에 따라서 반응하는 TextField를 넣고 싶었습니다. 몇몇 라이브러리를 설치해봤지만,
사용에 있어서 수정할 수 있는 제약이 많았습니다. 특히 가장 참을 수 없던건 stack에 넣었을 때, 높이를 rawValue로 지정해주지 않으면 모양이 흐트러져 버린다는 것이었습니다. 높이를 명확한 수치로 잡아버리면, font 변경에 유연하게 대처하지 못한 다는 점, 또 사용자의 디바이스에서 설정한 글씨 크기에 따라 앱의 글자 크기도 변경되는 Dynamic Font Size에도 대응할 수 없다는 점이 가장 큰 단점으로 생각되었습니다. 그래서 font의 사이즈에 따라 알아서 자신의 높이를 계산하는 TextField를 만들었습니다. 이때, `UIView`의 `intrinsicContentSize`를 오버라이드 하여 TextField의 기본 크기를 계산하도록 해주었습니다.

```swift
override var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.width, height: textInsets.top + textFieldHeight + textInsets.bottom)
}
```

이렇게 해서 height Constraint를 지정하지않고도 font의 size에 따라 높이가 자동으로 계산되는 TextField를 만들 수 있었습니다.

</details>

---

### 3. Device의 Network 상태에 따라 변화하는 책검색 View - NWPathMonitor

#### 스크린샷

![네트워크 상태에 따라 변화하는 View](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/62230b01-8d56-4be2-8f5a-d743a0baf161)

#### 디바이스의 인터넷 상태에 따라 책 검색 기능을 비활성화 할 수는 없을까?

> `Network` 프레임워크의 `NWPathMonitor`를 활용하여 기기의 현재 네트워크 상태에 따라 사용자에게 적절한 알림을 띄우고, View를 변경! Thread Safe함 까지 스마트하게 챙겼습니다.

<details>
<summary> 자세한 내용 보기 </summary>

검색을 통해 책의 정보를 가져오는 것은 알라딘 API를 통해서 하고 있었기 때문에 기기의 인터넷 연결이 반드시 필요한 기능입니다. 그래서 기기의 인터넷 연결이 끊어졌을 때 사용자에게 해당 사실을 알리고, 검색 기능을 막을 수 있는 방법을 고민했습니다. 먼저, `Network` 프레임워크의 `NWPathMonitor`로 기기의 현재 네트워크 상태를 전달 받을 수 있는 `NetworkMonitor` 클래스를 구현하여 `SceneDelegate`에서 앱이 실행될 때, 백그라운드에서 네트워크 감시가 시작되도록 했고, 앱이 종료될 때 함께 종료되도록 해주었습니다.

`NetworkMonitor` 클래스는 하나의 인스턴스에서 현재 기기의 네트워크 상태를 전달하면 충분하므로 Singleton 패턴을 적용했습니다. Custom Observable 타입인 `currentStatus` 변수에 `NWPath.Status(현재 네트워크 상태)`를 전달하여, ViewContoller에서 프로퍼티 감시자 `didSet`을 통해 변경되는 상태에 대해 대처할 수 있도록 했습니다. 상태 감시는 백그라운드에서 진행되지만, 바뀌는 상태에 대한 대응은 UI에서 일어나므로 Thread-safe 할 수 있도록 `currentStatus` 변수에 값을 전달할 때는 Main 스레드에서 값을 넘겨주도록 구현해주었습니다.

```swift
func startMonitoring() {
    monitor.start(queue: queue)
    currentStatus.value = monitor.currentPath.status
    monitor.pathUpdateHandler = { [weak self] path in
        DispatchQueue.main.sync {
            self?.currentStatus.value = path.status
        }
    }
}
```

</details>

## 🖌️ 앱 출시 회고

### 프로젝트 일정 관리

처음으로 앱의 기획서를 작성하는 것부터 UI 디자인, DB 테이블 짜기, 개발 그리고 배포까지 모두 혼자서 해보는 첫 경험이었습니다. 개발할 때는 주어진 시간을 몇개의 이터레이션으로 나눠 큼직한 주제를 분배하고, 하루마다 세부 task를 나눠 예상 시간과 걸린 시간을 비교해 가면서 작업 했습니다. 예상보다 시간이 적게 걸리거나 딱 맞은 작업들도 있었지만, 대부분은 예상보다 시간이 더 걸렸습니다. 왜 시간이 더 걸렸는지에 대해서 원인을 찾고 다음 이터레이션에는 같은 원인으로 시간이 늘어지지 않도록 노력하는 과정이 뭔가 진짜 '프로젝트를 하고 있다'라는 생각이 들어서 재밌었습니다. 제 개인의 역량을 어느정도 객관적으로 평가할 수 있는 저만의 지표도 될 수 있는 부분이라 앞으로 다른 프로젝트를 할 때도 적용하면 좋겠다고 생각했습니다.

### Realm 특성의 활용과 앱의 구조

이번 프로젝트에서 Realm을 활용해서 앱의 데이터를 저장하고 관리했습니다. 구현을 하다보니 모든 ViewModel이 결국은 Realm의 어떤 테이블 데이터를 가지고 있는 것을 발견했습니다. Realm의 'live objects'라는 특성도 살리지 못하고, 계속 CollectionView나 TableView의 DataSource를 위해서 매번 객체를 새로 불러와야 하는 단점도 있었습니다. 하나의 Store에서 각 ViewModel이 필요할 때마다 혹은 데이터가 변경될 때마다 새로 보내주는 구조로 만든다면 어땠을까 하는 생각이 마무리 단계에 들어서 좀 아쉬웠습니다. 이게 더 좋은 방법일지는 사실 아직은 알 수 없지만, 다음 프로젝트를 진행할 때는 앱을 만들기 전에 이런 구조적인 부분에서 좀 더 깊이 고민해서 더 효율적으로 데이터를 활용하고 싶습니다.

### View Component와 모듈화

여러 View에서 반복적으로 사용되는 컴포넌트들은 상속을 활용해서 custom하게 만드는 방식으로 잘 해결했다고 생각합니다. 그런데 책의 제목, 저자 등을 나타내는 Label과 같이 반복되는 뷰 객체들이 있어서 매 View Controller마다 정의하고 있었습니다. 이 부분을 효율적으로 처리하려면 어떻게 하면 좋을까 고민하다가 시간이 없어서 결국 매번 하던대로 일단 구현에 집중했었습니다. 다음 프로젝트에서는 디자인 패턴을 공부해서 이런 뷰 객체들을 지금보다 더 효율적으로 관리하고 싶습니다.

# BookitList

당신의 책읽기에 관한 모든 것을 기록합니다.

## 💬 프로젝트 소개

### [🔗 앱스토어 바로가기](https://apps.apple.com/kr/app/%EB%B6%81%ED%82%B7%EB%A6%AC%EC%8A%A4%ED%8A%B8-%EB%8B%B9%EC%8B%A0%EC%9D%98-%EB%8F%85%EC%84%9C-%EA%B8%B0%EB%A1%9D%EC%9D%98-%EB%AA%A8%EB%93%A0-%EA%B2%83/id6471903459)

### 작업 기간

- 개발: 2023.09.25 ~ 2023.11.12 (8주)
- 출시: 2023.11.13

### 업데이트 내역

| 버전  | 기간       | 업데이트 내용                                                                                                                      |
| ----- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| 1.1.1 | 2023.12.21 | - [feature] 노트의 내용을 Text Scan으로 작성할 수 있도록 함<br>- [bug fix] 노트에 연관 페이지 값으로 음수가 들어가지 못하도록 수정 |

### 기술 스택

- Deployment Target: iOS 15.0
- 개발 환경: Swift 5, Xcode 15.0.1
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

## 📂 파일 디렉토리 구조

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
│   │   ├── SeachBook
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

## 📱 주요 화면 및 기능

> ### Home(Reading Board) 화면
>
> | 기본 홈 화면                                                                                                | 데이터가 없을 때                                                                                                         | 지금 읽는 중인 책이 없을 때                                                                                                  | 읽을 예정인 책이 없을 때                                                                                                   |
> | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
> | ![홈 화면](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/9810d0d3-4ac1-4259-a01d-97e90574665c) | ![아무데이터도 없을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/f21d9f5e-6514-4dad-b2e5-89ea1fa7d52f) | ![읽을 예정인 책이 없을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/0a8f0977-4f00-47e9-beda-43261a56383e) | ![지금 읽는 책이 없을 때](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/8fa53f60-72ad-4434-84dc-af2179a89d43) |

> ### 도서 검색 화면
>
> | 검색 대기 화면                                                                                                     | 검색 중일 때                                                                                                              | 검색 결과 화면                                                                                                    | 오프라인 상태일 때                                                                                                   |
> | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
> | ![검색 대기 화면](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/432ec4df-c25b-4a83-8f0d-35a13de544d3) | ![검색 결과 기다리는 중](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/85e0999c-eb45-4a23-9434-2f54f990be59) | ![검색결과 화면](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/ed53b00a-0247-4482-a7ce-c6073f95167c) | ![오프라인 상태 시](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/5e270d8f-d838-4530-8959-ef0ebaa7f859) |

## ✨ 구현 Point!

### 1. 실제 책 사이즈의 비율을 반영한 책꽂이 - Modern Collection View

#### 스크린샷( Home & MyShelf Tab )

| ![Home](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/ea2171b3-13a4-458b-838f-8d43cfda3b35) | ![Grid](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/95c2e984-45c2-4708-a208-51b56a1312c2) | ![Shelf](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/4c831c9a-2e93-47d3-80fb-59cb9581dfad) | ![List](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/edaab05c-eabc-4e10-89c5-7bd95cb57c34) |
| -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |

#### 실제 책의 사이즈를 반영할 수는 없을까?

그리드, 책꽂이, 리스트형태로 책을 보여줄 때 책의 실제 크기를 반영해서 책의 높이나 두께와 같은 부분들도 눈에 띄게 보이면 재밌을 것 같았습니다. 다행히 제가 사용한 알라딘 API에서는 사이즈를 요청하면 실제 책의 가로, 세로, 높이에 대한 정보를 받아볼 수 있었습니다. 그래서 해당 정보를 활용해서 Cell에 반영해주자고 생각했습니다.

책커버 이미지가 셀을 전체적으로 덮는 BookCoverGridCell에서는 cell에 책의 정보를 받아올 프로퍼티에 속성 감시자를 활용했습니다. 책에 대한 정보가 셀에 전달되면, 커버 이미지를 불러와 imageView에 넣어주고 스냅킷의 `remakeConstraints` 메서드를 활용하여 imageView의 높이를 책의 가로세로 비율에 맞도록 재설정해주었습니다. 또, 오래된 책의 경우 size 정보가 없는 경우도 있었기 때문에 셀의 재사용 매커니즘 상 이전 책의 비율이 남아있지 않도록 하기 위해서 `prepareForReuse`에서 imageView의 크기를 셀의 크기와 동일하게 맞춰주도록 했습니다.

사실 이 작업에서 가장 공과 시간을 많이 들인 부분은 책꽂이처럼 보이도록 하는 `BookShelfCell`입니다. 책꽂이처럼 보이려면, 책의 두께와 높이를 반영해야 했는데, 두께가 충분하지 않으면 책 제목이 안 보이게 될 수도 있었고, Cell이 들어갈 CollectionView의 높이도 어느 정도 고려하지 않으면 높이차이가 없는 것처럼 보일 수 있었기 때문입니다. 속성 감시자를 활용해서 `remakeConstraints`로 cell의 레이아웃을 다시 잡아주는 동작은 그대로 가져가면서, cell의 minimumWidth와 maximumHeight을 계산해주었습니다. minimumWidth는 view의 layoutMargin과 titleLabel의 lineHeight로 계산해서 책의 두께가 제목을 보여주기에 충분하지 않으면, minimumWidth로 셀의 가로 길이가 반영되게 했습니다. maximumHeight는 셀의 화면에 그려지는 크기로 잡고 standardHeight를 그 수치의 80%로 잡아 API에서 사이즈 정보가 없는 경우에는 지정 높이로 그려지도록 했습니다. 그리고 실제 두께와 높이 비율을 계산해서 view에 사이즈를 반영했습니다.

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

### 2. font의 사이즈에 따라 자동으로 높이가 계산되는 CustomTextField - instrinctContentSize

#### 스크린샷

![CustomTextField](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/5fb6786b-6668-477a-a490-608730672d63)

#### 마음에 드는 라이브러리가 없다? 그럼 직접 구현하면 되지!!

View를 디자인할 때, 활성화 상태나 입력 여부에 따라서 반응하는 TextField를 넣고 싶었습니다. 몇몇 라이브러리를 설치해봤지만,
사용에 있어서 수정할 수 있는 제약이 많았습니다. 특히 가장 참을 수 없던건 stack에 넣었을 때, 높이를 rawValue로 지정해주지 않으면 모양이 흐트러져 버린다는 것이었습니다. 높이를 명확한 수치로 잡아버리면, font 변경에 유연하게 대처하지 못한 다는 점, 또 사용자의 디바이스에서 설정한 글씨 크기에 따라 앱의 글자 크기도 변경되는 Dynamic Font Size에도 대응할 수 없다는 점이 가장 큰 단점으로 생각되었습니다. 그래서 font의 사이즈에 따라 알아서 자신의 높이를 계산하는 TextField를 만들었습니다. 이때, `UIView`의 `intrinsicContentSize`를 오버라이드 하여 TextField의 기본 크기를 계산하도록 해주었습니다.

```swift
override var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.width, height: textInsets.top + textFieldHeight + textInsets.bottom)
}
```

이렇게 해서 height Constraint를 지정하지않고도 font의 size에 따라 높이가 자동으로 계산되는 TextField를 만들 수 있었습니다.

---

### 3. Device의 Network 상태에 따라 변화하는 책검색 View - NWPathMonitor

#### 스크린샷

![네트워크 상태에 따라 변화하는 View](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/62230b01-8d56-4be2-8f5a-d743a0baf161)

#### 디바이스의 인터넷 상태에 따라 책 검색 기능을 비활성화 할 수는 없을까?

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

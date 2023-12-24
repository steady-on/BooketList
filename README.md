# BookitList

당신의 책읽기에 관한 모든 것을 기록합니다.

## 💬 프로젝트 소개

### [🔗 앱스토어 바로가기](https://apps.apple.com/kr/app/%EB%B6%81%ED%82%B7%EB%A6%AC%EC%8A%A4%ED%8A%B8-%EB%8B%B9%EC%8B%A0%EC%9D%98-%EB%8F%85%EC%84%9C-%EA%B8%B0%EB%A1%9D%EC%9D%98-%EB%AA%A8%EB%93%A0-%EA%B2%83/id6471903459)

| ![title](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/2446e332-2144-48c3-97a2-cff95c9299ae) | ![title](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/4f51fd4c-508f-4e2b-bce4-0354d2991bf9) | ![title](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/e7a6a516-ad6b-4cdb-9ef0-509f30be1be8) | ![title](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/de432667-39d5-459a-b9df-10d9ccdf880c) | ![title](https://github.com/steady-on/SeSAC_iOS_3rd/assets/73203944/1c37e73a-5002-49fa-8fbc-43ff4b9f680d) |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |

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
- 라이브러리: Realm, SnapKit, KingFisher, Alamofire, Firebase
- 아키텍처: MVVM
- 그 외 활용 기술: Codable, Compositional Layout, Diffable DataSource, NWPathMonitor
- open API: 알라딘 API

### 핵심 구현 요소

- Custom Observable class를 정의하고 MVVM을 적용하는 것으로 `ViewController`는 화면을 그리는 역할을, `ViewModel`은 데이터 및 비즈니스 로직 관리, 화면 전환 요청 등을 담당하도록 역할 분리
- Custom Component를 구현하여 코드의 재사용성을 높임
- Alamofire의 URLRequestConvertible으로 Routing 패턴을 적용하여 요청 URL의 엔드포인트를 효율적으로 관리
- NWPathMonitor를 활용하여 기기의 네트워크 통신 상태에 따라 도서 검색 기능의 활성화 여부를 반응형 View로 구성
- Swift의 Generic을 활용하여 타입에 유연하게 동작할 수 있는 코드 작성
- 프로토콜을 정의하고 하나의 Type으로 사용하여 재사용 가능한 코드 작성

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

## 🚨 Trouble Shooting

- instrinctContentSize를 활용해서 Custom TextField의 Height이 자동으로 계산되도록 한것
- 책의 사이즈를 가져와서 Cell에 반영한것
-

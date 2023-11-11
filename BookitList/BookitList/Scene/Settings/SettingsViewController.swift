//
//  SettingsViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit
import MessageUI

final class SettingsViewController: UITableViewController {
    
    private let termsItems = [
        SettingsItem(title: "개인정보 처리방침", content: Terms.privacyPolicy, connectedViewController: TextModalViewController.self),
        SettingsItem(title: "오픈소스 라이센스", content: Terms.openSourceLicense, connectedViewController: TextModalViewController.self)
    ]
    
    private let customerSupportItems = [
        SettingsItem(title: "문의하기 및 의견보내기", content: "roen.steady.on@gmail.com", connectedViewController: nil)
    ]
    
    private let appInfoItems = [
        SettingsItem(title: "버전 정보", content: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, isAccessary: false, connectedViewController: nil)
    ]
    
    private var dataSource: SettingsDataSource! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Section, SettingsItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "환경 설정"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .background
        
        configureDataSource()
        configureSnapshot()
    }

    private func configureDataSource() {
        dataSource = SettingsDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = UITableViewCell()
            
            guard let section = Section(rawValue: indexPath.section) else { return cell }
            
            var cellConfiguration = cell.defaultContentConfiguration()
            cellConfiguration.text = itemIdentifier.title
            cellConfiguration.textProperties.font = .preferredFont(forTextStyle: .body)
            cellConfiguration.secondaryTextProperties.color = .secondaryLabel
            
            switch section {
            case .terms:
                break
            case .customerSupport:
                cellConfiguration.secondaryText = itemIdentifier.content
                cellConfiguration.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
            case .appInfo:
                cellConfiguration.secondaryText = itemIdentifier.content
                cellConfiguration.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
                cellConfiguration.prefersSideBySideTextAndSecondaryText = true
            }
            
            cell.contentConfiguration = cellConfiguration
            cell.accessoryType = itemIdentifier.isAccessary ? .disclosureIndicator : .none
            
            return cell
        }
    }
    
    private func configureSnapshot() {
        snapshot.appendSections([.terms, .customerSupport, .appInfo])
        snapshot.appendItems(termsItems, toSection: .terms)
        snapshot.appendItems(customerSupportItems, toSection: .customerSupport)
        snapshot.appendItems(appInfoItems, toSection: .appInfo)
        dataSource.apply(snapshot)
    }
    
    
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section), let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch section {
        case .terms:
            guard let content = item.content else { return }
            let viewController = TextModalViewController(title: item.title, content: content)
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true)
        case .customerSupport:
            showMailComposeView()
        case .appInfo:
            break
        }
        
    }
    
    private func showMailComposeView() {
        guard MFMailComposeViewController.canSendMail() else {
            showAlertForCannotSendMail()
            return
        }
        
        let messageBody =
        """
        내용을 입력해 주세요.
        
        =========================
        Device: \(UIDevice.current.model)
        iOS Version: \(UIDevice.current.systemVersion)
        App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
        =========================
        """
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.setToRecipients(["roen.steady.on@gmail.com"])
        mailComposeViewController.setSubject("[북킷리스트] 문의하기 및 의견보내기")
        mailComposeViewController.setMessageBody(messageBody, isHTML: false)
        mailComposeViewController.delegate = self
        present(mailComposeViewController, animated: true)
    }
    
    private func showAlertForCannotSendMail() {
        let alert = UIAlertController(title: "메일을 보낼 수 없습니다", message: "알 수 없는 원인으로 메일을 작성할 수 없습니다. 아이폰의 메일설정을 확인해주세요.", preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "알겠어요", style: .cancel)
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
}

extension SettingsViewController {
    enum Section: Int {
        case terms // 개인 정보 처리 방침, DB제공, 오픈소스 라이센스
        case customerSupport // 문의하기, 리뷰 남기기
        case appInfo // 버전 정보
        
        var title: String {
            switch self {
            case .terms: return "약관 및 정책"
            case .customerSupport: return "고객 지원"
            case .appInfo: return "앱 정보"
            }
        }
    }
    
    final class SettingsItem: Hashable {
        let title: String
        let content: String?
        let isAccessary: Bool
        let connectedViewController: UIViewController.Type?
        
        init(title: String, content: String?, isAccessary: Bool = true, connectedViewController: UIViewController.Type?) {
            self.title = title
            self.content = content
            self.isAccessary = isAccessary
            self.connectedViewController = connectedViewController
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: SettingsItem, rhs: SettingsItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        private let identifier = UUID()
    }
    
    final class SettingsDataSource: UITableViewDiffableDataSource<Section, SettingsItem> {
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let sectionKind = Section(rawValue: section)
            return sectionKind?.title
        }
        
        override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            guard let sectionKind = Section(rawValue: section), sectionKind == .terms else { return nil }
            return "도서 DB 제공 : 알라딘 인터넷서점(www.aladin.co.kr)"
        }
    }
}




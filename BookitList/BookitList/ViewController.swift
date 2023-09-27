//
//  ViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AladinAPIManager().request(type: AladinSearchResponse.self, api: .itemSearch(query: "", isEbook: false, page: 1)) { result in
            dump(result)
        }
    }


}


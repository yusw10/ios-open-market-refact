//
//  MainViewModel.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/12/17.
//

import Foundation

final class MainViewModel: ViewModelBuilder {
    
    var onErrorHandling : ((APIError) -> Void)?
    
    private let networkAPI: SessionProtocol
    
    init(networkAPI: SessionProtocol) {
        self.networkAPI = networkAPI
    }
    enum MainViewAction {
        case listFetch
    }
    
    struct Input {
        let pageInfoInput: Observable<(pageNumber: Int, itemsPerPage: Int)>
    }
    
    struct Output {
        let fetchedProductListOutput: Observable<[Product]>
    }
    
    func transform(input: Input) -> Output {
        
        let fetchedProductListOutput = Observable<[Product]>([])
        
        input.pageInfoInput.subscribe { (pageNumber: Int, itemsPerPage: Int) in
            self.fetchProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage) { (result: Result<[Product], APIError>) in
                switch result {
                case .success(let productList):
                    fetchedProductListOutput.value = productList
                case .failure(let failure):
                    self.onErrorHandling?(failure)
                }
            }
        }
        
        return .init(
            fetchedProductListOutput: fetchedProductListOutput
        )
    }
    
    private func fetchProductList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<[Product],APIError>) -> Void) {
        guard let request = OpenMarketRequestDirector().createGetRequest(
            pageNumber: pageNumber,
            itemsPerPage: itemsPerPage
        ) else {
            return completion(.failure(APIError.request))
        }
        
        networkAPI.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                guard let productList = JsonDecoderManager.shared.decode(
                    from: data,
                    to: ProductList.self
                ) else { return }
                return completion(.success(productList.pages))
            case .failure(_):
                return completion(.failure(APIError.response))
            }
        }
    }
}

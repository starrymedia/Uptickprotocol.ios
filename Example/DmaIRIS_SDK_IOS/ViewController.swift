//
//  ViewController.swift
//  DmaIRIS_SDK_IOS
//
//  Created by 447690182@qq.com on 11/14/2020.
//  Copyright (c) 2020 447690182@qq.com. All rights reserved.
//

import UIKit
import UptickProtocolIRISnet
import GRPC
import Logging
import web3swift
import secp256k1_swift
import Alamofire

public struct PublicKey {
    var type:String = ""
    var value: String = ""

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let url = "34.80.202.172"
        let chainId = "nyancat-8"
        let merchantUrl = "http://192.168.1.106:8091"

        IRISServive.host = url
        IRISServive.port = 9090
        IRISServive.chainId = chainId
        IRISServive.defaultCoin = "unyan"
        MerchantService.nodeUrl = merchantUrl
        RpcService.rpcUrl = "http://\(url):26657"
        
        let tokenId = "uptick\(TxUtils.identifier)"
        let denom = Denom<SouvenirCardInfo>()
        denom.create = "iaa1fz8c0sngf0nmhxhf3m6prs7sp05w0lvmkuwrvk"
        denom.name = tokenId
        denom.denom = tokenId
        SouvenirCardService.issueDenom(denom: denom,
                                       privateKey: "aab7ef7aacda03ae6c45916d458981edb3c2a060c9cd6c79efdf03df73cf1016",
                                       method: .broadcastTxAsync) { value in
            print(value.result?.hash ?? "")
            self.quertHash(hash: value.result?.hash ?? "") {
                print("result success")
            } failed: {
                print("result failed")
            }
        } errorCallback: { error in
           print(error)
        }


    
        
//        var isbreak = false
//        DispatchQueue.global().async {
//
//            for index in 0..<10 {
//                if isbreak { return }
//                let group = DispatchGroup()
//                group.enter()
//                QueryService.queryTxByHash(hash: "EB34148AC6E00F04539FC8055A92BF072B1A80205A6E5CCAE5358150473BA3C1") { result in
//                    print(index)
//                    print(result)
//                    if index == 3 {
//                        group.leave()
//                        isbreak = true
//                        print("success")
//                    } else {
//                        isbreak = false
//                        if index == 9 {
//                            group.leave()
//                            isbreak = true
//                            print("failed")
//                        }
//                    }
//                } errorCallBack: { error in
//                    print(error)
//                    print("failed")
//                    isbreak = true
//                    group.leave()
//                }
//                group.wait()
//            }
//
//        }

        

//        let wallet = WalletManager.create()
//        print(wallet.mnemonics)
        
//        let tokenId = "uptick\(TxUtils.identifier)"
//
//        let cardInfo = SouvenirCardInfo()
//        cardInfo.tokenId = tokenId
//        cardInfo.denomId = "dhjvc"
//        cardInfo.name = "Fuchs"
//        cardInfo.description = "测试奇怪的bug"
//        cardInfo.backgroundColor = "#ffe2a9"
//        cardInfo.minter = "Uptick"
//        cardInfo.imgUrl = "测试奇怪的bug"
//        cardInfo.minterLogoUrl = "测试奇怪的bug"
//        cardInfo.issuerName = "nickName"
//        cardInfo.issuerAddr = "address"
//        cardInfo.issuerLogoUrl = "userImage"
//        cardInfo.issuesTime = Int64(Date().timeIntervalSince1970) * 1000
//
//        SouvenirCardService.mintTokenGas(ticketEntities: [cardInfo],
//                                         sender: "iaa1fz8c0sngf0nmhxhf3m6prs7sp05w0lvmkuwrvk",
//                                         recipient: "iaa1fz8c0sngf0nmhxhf3m6prs7sp05w0lvmkuwrvk",
//                                         privateKey: "aab7ef7aacda03ae6c45916d458981edb3c2a060c9cd6c79efdf03df73cf1016",
//                                         isSign: true,
//                                         feeAddress: "iaa1fz8c0sngf0nmhxhf3m6prs7sp05w0lvmkuwrvk",
//                                         fee: "1",
//                                         method: .broadcastTxAsync) { tx in
//
//            print(tx.authInfo.fee.gasLimit)
////            SouvenirCardService.mintToken(tx: tx,
////                                         method: .broadcastTxAsync) { value in
////             print(value)
////
////            } errorCallback: { error in
////
////            }
//
//         } errorCallback: { error in
//            print(error)
//
//         }
        
        let dic = ["callback":"http://192.168.1.106:7999/api/1.0/fee/onSale.do?receiver=iaa1fgatwy03e8qq5j52h66h72mawj5l7vzvkffn9y&amount=0&contractAddress=uptick6b098c797d1e14ed383300fbb37279d2&payAddress=iaa1x446u0sngscm7kgpe37mu863a2pq74vsycq5wm"]
    

     }
    
    
    func quertHash(hash: String, success: @escaping () -> (),failed: @escaping () -> ()) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "someLabel")
        let sema = DispatchSemaphore(value: 0)
        queue.async {
            var everythingOkay:Bool = false
            for i in 0..<10 {
                
                sleep(2)

                print("Loop iteration: \(i)")
                if !everythingOkay {
                    group.enter()
                    QueryService.queryTxByHash(hash: hash) { result in
                        if result.tx_result.code == 0 {
                            print("Upload successful!")
                            everythingOkay = true
                            success()
                        } else {
                            print("Upload failed!")
                            everythingOkay = true
                            failed()
                        }
                        group.leave()
                        sema.signal()
                    } errorCallBack: { error in
                        print("Error: \(error)")
                        everythingOkay = false
                        if i == 9 {
                            failed()
                        }
                        group.leave()
                        sema.signal()
                    }
                    sema.wait()
                } else {
//                    failed()
                    break
                }
                
            }
        }

        group.notify(queue: queue) {
            DispatchQueue.main.async {
                print("Done!")
            }
        }
    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct Login: Encodable {
    let email: String
    let password: String
}



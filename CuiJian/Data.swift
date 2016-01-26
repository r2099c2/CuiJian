//
//  Data.swift
//  CuiJian
//
//  Created by Rick on 16/1/26.
//  Copyright © 2016年 Rick. All rights reserved.
//

import Foundation

class Data {
    var dataArray: [Timeline?] = []
    
    init() {
        getData()
    }
    
    func getData() {
        let session: NSURLSession = NSURLSession.sharedSession()
        let url = NSURL(string: "http://cuijian.logicdesign.cn/api.php?term_id=3")
        let request = NSMutableURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            do {
                let dic:[NSDictionary] = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [NSDictionary]
                for value in dic {
                    let item = Timeline()
                    item.setValuesForKeysWithDictionary(value as! [String : AnyObject])
                    self.dataArray.append(item)
                    print(item)
                }
                
            }
            catch{
                print("Error: \(error)")
            }
            
//            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
//                print("error")
//                return
//            }
//            
//            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print(dataString)
            
        }
        
        task.resume()
    }
}

//
//  SongListViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/29.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

class SongListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let songList = ["光冻","死不回头","鱼鸟之恋","外面的妞","酷瓜树","金色早晨","滚动的蛋","浑水湖漫步","阳光下的梦"]
   
    @IBOutlet weak var songListTable: UITableView! {
        didSet {
            songListTable.delegate = self
            songListTable.dataSource = self
            songListTable.tableFooterView = UIView(frame: CGRectZero)
        }
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "songListCellIdentifier"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SongListCell
        
        cell.songListIndex.text = String(indexPath.row)
        cell.songName.text = songList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }

}

//
//  SongListViewController.swift
//  CuiJian
//
//  Created by Rick on 16/1/29.
//  Copyright © 2016年 Rick. All rights reserved.
//

import UIKit

protocol SongListDelegate: class {
    func changeSongIndex(newIndex: Int)
}

class SongListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let songList = ["光冻","死不回头","鱼鸟之恋","外面的妞","酷瓜树","金色早晨","滚动的蛋","浑水湖漫步","阳光下的梦"]
    
    var songListDelegte: SongListDelegate?
   
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
    
    @IBAction func listenAllSong(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://y.qq.com/index.html#type=album&mid=0010bTB83JjfMG")!)
    }
    
    //MARK: - TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "songListCellIdentifier"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SongListCell
        
        cell.songListIndex.text = String(indexPath.row + 1)
        cell.songName.text = songList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        songListDelegte?.changeSongIndex(indexPath.row)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

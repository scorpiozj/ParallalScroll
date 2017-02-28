//
//  ZZScrollViewController.swift
//  ParallalScroll
//
//  Created by ZhuJiang on 17/2/4.
//  Copyright © 2017年 Charles. All rights reserved.
//

import UIKit

extension UIScrollView {
    func isScrollToBottom() -> Bool {
        let contentHeight: CGFloat = self.contentOffset.y + self.frame.size.height
        let contentSizeHeight = self.contentSize.height
        return contentHeight >= contentSizeHeight
    }
}


class ZZScrollViewController: UIViewController {

    @IBOutlet weak var tableViewlist: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBar: UIView!
    @IBOutlet weak var scrollParent: UIScrollView!
    
    var goingUp: Bool?
    var childScrollingDownDueToParent = false
    
    let kScrollOffsetHeight: CGFloat  = 40.0
    
    let arrayTableData = ["Bean", "Roy",  "Beard", "Charles A. Beaumont and Fletcher", "Beck", "Glenn", "Becker", "Carl", "Beckett", "Samuel", "Beddoes", "Mick", "Beecher", "Henry Ward", "Beethoven", "Ludwig van", "Bean", "Roy",  "Beard", "Charles A. Beaumont and Fletcher", "Beck", "Glenn", "Becker", "Carl", "Beckett", "Samuel", "Beddoes", "Mick", "Beecher", "Henry Ward", "Beethoven", "Ludwig van"]
    
    let cellIdentifier = "nestedTableCellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewlist.dataSource = self
        self.tableViewlist.delegate = self
        self.tableViewlist.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.scrollParent.delegate = self
        
//        self.navigationController?.navigationBar.barTintColor = UIColor.red
//        self.title = "Test"
//        self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: UIColor.clear)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()

        self.view.backgroundColor = UIColor.blue
        self.scrollParent.backgroundColor = UIColor.cyan
        
        self.scrollParent.delaysContentTouches = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        if self.navigationController == nil {
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Private
    func addNavItems(){
        let leftItem = UIBarButtonItem.init(title: "Left", style: UIBarButtonItemStyle.plain, target: self, action: #selector(test(_:)))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem.init(title: "Righ", style: UIBarButtonItemStyle.done, target: self, action: #selector(test(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    func test(_ sender: Any){
        
    }
}

extension ZZScrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "#\(indexPath.row)"
        cell.detailTextLabel?.text = arrayTableData[indexPath.row]
        return cell
    }
}
//MARK: UITableViewDelegate
extension ZZScrollViewController: UITableViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
//        ZZDebugLog(object: scrollView)
        
        goingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        
        var adjustOffset: CGFloat = 0
        
        if let barFrame = self.navigationController?.navigationBar.frame{
            adjustOffset = barFrame.origin.y + barFrame.size.height
        }
        else {
            let statueBarHidden = self.prefersStatusBarHidden
            adjustOffset = statueBarHidden ? 0.0 : 20.0
        }
        let parentViewMaxContentYOffset = self.scrollParent.contentSize.height - self.scrollParent.frame.height - adjustOffset
        
        if goingUp! {
            ZZDebugLog(object: NSString.init(format: "scrollOffset=%@, tableviewOffset=%@", NSStringFromCGPoint(self.scrollParent.contentOffset), NSStringFromCGPoint(self.tableViewlist.contentOffset)))
            if scrollView == self.tableViewlist {
                if self.scrollParent.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    self.scrollParent.contentOffset.y = max(min(self.scrollParent.contentOffset.y + self.tableViewlist.contentOffset.y , parentViewMaxContentYOffset), 0)
                    self.tableViewlist.contentOffset.y = 0
                    
                }
            }
            
            if scrollView == self.scrollParent {
                if self.scrollParent.contentOffset.y > parentViewMaxContentYOffset {
                    self.scrollParent.contentOffset.y = parentViewMaxContentYOffset
                    
                    self.scrollParent.isScrollEnabled = false
                }
                if self.tableViewlist.isScrollToBottom() {
                    ZZDebugLog(object: "")
                    self.scrollParent.isScrollEnabled = false
                }
            }
        }
        else {
            if scrollView == self.tableViewlist {
                if self.tableViewlist.contentOffset.y < 0 && self.scrollParent.contentOffset.y > 0 {
                    self.scrollParent.contentOffset.y = max(self.scrollParent.contentOffset.y - abs(self.tableViewlist.contentOffset.y), 0)
                }
            }
            
            if scrollView == self.scrollParent {
                if self.tableViewlist.contentOffset.y > 0 && self.scrollParent.contentOffset.y < parentViewMaxContentYOffset {
                    childScrollingDownDueToParent = true
                    self.tableViewlist.contentOffset.y = max(self.tableViewlist.contentOffset.y - (parentViewMaxContentYOffset - self.scrollParent.contentOffset.y ), 0)
                    self.scrollParent.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
            }
        }
        
        let navColor = UIColor.white//UIColor.init(colorLiteralRed: 0.0, green: 175.0/255.0, blue: 240.0/255.0, alpha: 1)
        let parentOffset = self.scrollParent.contentOffset.y
        var colorAlpha: CGFloat = 0.0
        if parentOffset > kScrollOffsetHeight {
            colorAlpha = min(1, 1 - ((kScrollOffsetHeight + 64 - parentOffset)/64))
        }
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: navColor.withAlphaComponent(colorAlpha))
        if colorAlpha > 0.5 {
            self.addNavItems()
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        ZZDebugLog(object: "Decelerating")
        if self.tableViewlist.isScrollToBottom() {
            ZZDebugLog(object: "")
            self.scrollParent.isScrollEnabled = false
        }
        else {
            self.scrollParent.isScrollEnabled = true
        }
        
    }
    
}

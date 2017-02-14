//
//  ZZScrollViewController.swift
//  ParallalScroll
//
//  Created by ZhuJiang on 17/2/4.
//  Copyright © 2017年 Charles. All rights reserved.
//

import UIKit

class ZZScrollViewController: UIViewController {

    @IBOutlet weak var tableViewlist: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBar: UIView!
    @IBOutlet weak var scrollParent: UIScrollView!
    
    var goingUp: Bool?
    var childScrollingDownDueToParent = false
    
    
    let arrayTableData = ["Bean", "Roy",  "Beard", "Charles A. Beaumont and Fletcher", "Beck", "Glenn", "Becker", "Carl", "Beckett", "Samuel", "Beddoes", "Mick", "Beecher", "Henry Ward", "Beethoven", "Ludwig van", "Bean", "Roy",  "Beard", "Charles A. Beaumont and Fletcher", "Beck", "Glenn", "Becker", "Carl", "Beckett", "Samuel", "Beddoes", "Mick", "Beecher", "Henry Ward", "Beethoven", "Ludwig van"]
    
    let cellIdentifier = "nestedTableCellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewlist.dataSource = self
        self.tableViewlist.delegate = self
        self.tableViewlist.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.scrollParent.delegate = self
        // Do any additional setup after loading the view.
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

extension ZZScrollViewController: UITableViewDelegate {
    //MARK: Scroll
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
            if scrollView == self.tableViewlist {
                if self.scrollParent.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    self.scrollParent.contentOffset.y = max(min(self.scrollParent.contentOffset.y + self.tableViewlist.contentOffset.y , parentViewMaxContentYOffset), 0)
                    self.tableViewlist.contentOffset.y = 0
                    
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
    }
    
    
}

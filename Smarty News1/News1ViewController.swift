//
//  News1ViewController.swift
//  Smarty News1
//
//  Created by User on 2017/07/11.
//  Copyright © 2017年 Yusuke Hirose. All rights reserved.
//

import UIKit

class News1ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,XMLParserDelegate{

    
    var tableView:UITableView = UITableView()
    
    var refreshControl:UIRefreshControl!
    
    var webView:UIWebView = UIWebView()
    
    var goButton:UIButton!
    
    var backButton:UIButton!
    
    var cancelButton:UIButton!
    
    var dotsView:DotsLoader! = DotsLoader()
    
    var parser = XMLParser()
    var totalBox = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = String()
    var titleString = NSMutableString()
    var linkString = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //　背景画像を作る
        let imageView = UIImageView()
        //imageViewを画面いっぱいに広げる
        imageView.frame = self.view.bounds
        imageView.image = UIImage(named:"1.jpg")
        //imageViewを画面へ貼り付け
        self.view.addSubview(imageView)
        
    //引っ張って更新
        refreshControl = UIRefreshControl()
        //更新中の回るマークの色を白に指定
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
    
    //tableViewを作成
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0)
        tableView.backgroundColor = UIColor.clear
        //tableViewに更新中マークを貼り付け
        tableView.addSubview(refreshControl)
        //もとのViewControllerのViewにtableViewを貼り付ける
        self.view.addSubview(tableView)
        
    //webView
        webView.frame = tableView.frame
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        self.view.addSubview(webView)
        webView.isHidden = true
        
    //1つ進むボタン
        goButton = UIButton()
        goButton.frame = CGRect(x: self.view.frame.size.width - 50, y: self.view.frame.size.height - 128, width: 50, height: 50)
        //fot以下でページの状態を指定　何もない時normal
        goButton.setImage(UIImage(named:"go.png") ,for: .normal)
        //goButtonを押した時の処理
        goButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        self.view.addSubview(goButton)
      
    //戻るボタン
        backButton = UIButton()
        backButton.frame = CGRect(x: 10, y: self.view.frame.size.height - 128, width: 50, height: 50)
        backButton.setImage(UIImage(named:"back.png"), for: .normal)
        backButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        self.view.addSubview(backButton)

    //キャンセルボタン
        cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 10, y: 80, width: 50, height: 50)
        cancelButton.setImage(UIImage(named:"cancel.png"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        goButton.isHidden = true
        backButton.isHidden = true
        cancelButton.isHidden = true
        
    //ドッツビュー
        dotsView.frame = CGRect(x: 0, y: self.view.frame.size.height / 3, width: self.view.frame.size.width, height: 100)
        //点の数
        dotsView.dotsCount = 5
        //点の大きさ
        dotsView.dotsRadius = 10
        //貼り付け
        self.view.addSubview(dotsView)
        
        dotsView.isHidden = true
        
    //XMLを解析する(パース)
        let url:String = "https://news.yahoo.co.jp/pickup/domestic/rss.xml"
        let urlToSend:URL = URL(string:url)!
        parser = XMLParser(contentsOf:urlToSend)!
        totalBox = []
        parser.delegate = self
        //解析を始める
        parser.parse()
        //tableViewの更新
        tableView.reloadData()
        
        
    }
    
    func refresh(){
    
        perform(#selector(delay), with: nil, afterDelay: 2.0)
    
    }
    
    func delay(){
    
    //XMLを解析する(パース)
        let url:String = "https://news.yahoo.co.jp/pickup/domestic/rss.xml"
        let urlToSend:URL = URL(string:url)!
        parser = XMLParser(contentsOf:urlToSend)!
        totalBox = []
        parser.delegate = self
        //解析を始める
        parser.parse()
        //tableViewの更新
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    //webviewを1ページ進める
    func nextPage(){
    
        webView.goForward()
    
    }
    
    //webViewを1ページ戻す
    func backPage(){
    
        webView.goBack()
        
    }
    
    //webViewを隠す
    func cancel(){
        
        webView.isHidden = true
        goButton.isHidden = true
        backButton.isHidden = true
        cancelButton.isHidden = true
    
    }
    
    //tableViewの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt IndexPath: IndexPath) -> CGFloat{
    
        return 100
        
    }
    
    //セクションの数
    func numberOfSections(in tableView:UITableView) -> Int {
    
        return 1
        
    }

    //セクションの中のセルの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return totalBox.count
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.backgroundColor = UIColor.clear
        //セルは最初からtextLabelとimageViewを持っている
        //cell.textLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forkey: "title") as? String
        cell.textLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = UIColor.white
        
        //cell.detailTextLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forkey: "link") as? String
        cell.detailTextLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 9.0)
        cell.detailTextLabel?.textColor = UIColor.white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //webViewを表示する
        let linkURL = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
        let urlStr = linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url:URL = URL(string:urlStr!)!
        let urlRequest = NSURLRequest(url: url)
        webView.loadRequest(urlRequest as URLRequest)
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        dotsView.isHidden = false
        dotsView.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        dotsView.isHidden = true
        dotsView.stopAnimating()
        webView.isHidden = false
        goButton.isHidden = false
        backButton.isHidden = false
        cancelButton.isHidden = false
        
    }
    
    //html開始タグを見つけたとき
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if element == "item"{
        
            elements = NSMutableDictionary()
            elements = [:]
            titleString = NSMutableString()
            titleString = ""
            linkString = NSMutableString()
            linkString = ""
            
            
        }
        
    }
    
    //htmlタグの間にデータがあった時(開始タグと終了タグで括られた箇所にデータが存在した時に実行されるメソッド)
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title"{
        
            titleString.append(string)
            
        }else if element == "link"{
        
            linkString.append(string)
        
        }
        
        
    }
    
    //html終了タグ見つけた時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //itemという要素の中にあるなら,
        if elementName == "item"{
            
            //titleString(linkString)の中身が空でないなら,
            if titleString != ""{
                
                 //elementsにキー値を付与しながらtitleString(linkString)をセットする
                elements.setObject(titleString, forKey: "title" as NSCopying)
            
            }
            
            if linkString != ""{
                
                elements.setObject(linkString, forKey: "link" as NSCopying)
                
            }
            
            //totalBoxの中にelementsを入れる
            totalBox.add(elements)
        }
        
        
       
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

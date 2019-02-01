//
//  ViewController.swift
//  QuitaLikePicker
//
//  Created by 山本竜也 on 2019/1/27.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var likeCountLabel1: UILabel!
    @IBOutlet weak var nameLabel1: UILabel!
    
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var likeCountLabel2: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var likeCountLabel3: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    
    @IBOutlet weak var titleLabel4: UILabel!
    @IBOutlet weak var likeCountLabel4: UILabel!
    @IBOutlet weak var nameLabel4: UILabel!
    
    
    //値がないときは　! をつける
    var centerOfCard:CGPoint!
    var people  = [UIView]()
    var selectedCardCount: Int = 0
    
    // likeされたらlikedNameに入れていく
    // var name = ["なつき","あかね","さくら","カルロス"]
    var likedName = [String]()
    var ArticleTitle = [String]()
    var UserName = [String]()
    var LikeCount = [Int]()
    var url = [String]()
    var updateAt = [String]()
    var selectArticleIndex = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //初期値を保存してる変数
        centerOfCard = basicCard.center
        // 配列に画像を入れている
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
        
        getQiitaArticle()
        
    }
    
    func getQiitaArticle(){
        Alamofire.request("https://qiita.com/api/v2/items?page=13&per_page=4", method: .get,
                          encoding: URLEncoding.default)
            .responseJSON{(response: DataResponse<Any>) in
                if(response.response?.statusCode == 200){
                    guard let obj = response.result.value else {
                        return
                    }
                    let json = JSON(obj)
                    print(json)
                    json.forEach { (_, json) in
                        self.ArticleTitle.append(json["title"].string!)
                        self.url.append(json["url"].string!)
                        self.LikeCount.append(json["likes_count"].int!)
                        self.updateAt.append(json["updated_at"].string!)
                        self.UserName.append(json["user"]["name"].string!)
                    }
                    print(self.ArticleTitle)
                    print(self.url)
                    print(self.UserName)
                   
                    self.showLabel()
                }
                
                
        }
    }
    
    func showLabel(){
        
//        for i in 0..<4 {
//            ("titleLabel\(i + 1)").text = self.ArticleTitle[i]
//        }
        
        self.titleLabel1.text = self.ArticleTitle[0]
        self.nameLabel1.text = self.UserName[0]
        self.likeCountLabel1.text = String(self.LikeCount[0])
        
        self.titleLabel2.text = self.ArticleTitle[1]
        self.nameLabel2.text = self.UserName[1]
        self.likeCountLabel2.text = String(self.LikeCount[1])
        
        self.titleLabel3.text = self.ArticleTitle[2]
        self.nameLabel3.text = self.UserName[2]
        self.likeCountLabel3.text = String(self.LikeCount[2])
        
        self.titleLabel4.text = self.ArticleTitle[3]
        self.nameLabel4.text = self.UserName[3]
        self.likeCountLabel4.text = String(self.LikeCount[3])
    }
    
    func resetCard(){
        // 位置を戻す
        basicCard.center = self.centerOfCard
        //角度を元に戻す
        basicCard.transform = .identity
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushList" {
            // 遷移先の ListViewController を代入している
            let vc = segue.destination as! ListViewController
            vc.likedName = likedName
        }
    }
    @IBAction func didTouchedLikeButton(_ sender: UIButton) {
        flyCardToRight()
    }
    
    @IBAction func didTouchedDisLikeButton(_ sender: UIButton) {
        flyCardToLeft()
    }
    
    
    
    
    // @IBAction はMainStoryBoard から紐づいているっていう宣言
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        // カードも一緒に動かす！準備
        let card = sender.view!
        // どれくらい移動したかの位置情報が入る　in: view は大元のviewのこと。
        let point = sender.translation(in: view)
        // スワイプされた分を動かす。point.x や　point.y が動いた分ってこと。
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        
        // 角度を変える ラジアン計算　0.785は45度
        let xFromCenter = card.center.x - view.center.x
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
        
        // 画像を出す処理
        // 右に行ったら
        if xFromCenter > 0 {
            likeImageView.image = UIImage(named: "good")
            likeImageView.alpha = 1
            // assets で　templateimageになっていたら、色を変えることができる。
            likeImageView.tintColor = UIColor.red
            // 左に行ったら
        } else if xFromCenter < 0 {
            likeImageView.image = UIImage(named: "bad")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.blue
            
        }
        
        // クロージャ　無名関数みたいなもの。
        if sender.state == UIGestureRecognizer.State.ended{
            // 左にスワイプ
            // 75point
            if card.center.x < 75 {
                flyCardToLeft()
                return
                //右にスワイプ
            }else if card.center.x > self.view.frame.width - 75 {
                flyCardToRight()
                return
            }
            
            // 小さいスワイプだったら、カードを初期値に戻す
            UIView.animate(withDuration: 0.2, animations: {
                self.resetCard()
                self.people[self.selectedCardCount].center = self.centerOfCard
                self.people[self.selectedCardCount].transform = .identity
            })
            // 真ん中に戻したら画像を消すため
            likeImageView.alpha = 0
        }
    }
    
    func flyCardToRight(){
        UIView.animate(withDuration: 0.2, animations: {
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 500, y: self.people[self.selectedCardCount].center.y );
            self.resetCard()
        })
        likeImageView.alpha = 0
        selectArticleIndex.append(selectedCardCount)
        selectedCardCount += 1
        if selectedCardCount >= people.count{
            performSegue(withIdentifier: "pushList", sender: self)
        }
    }
    
    func flyCardToLeft(){
        UIView.animate(withDuration: 0.2, animations: {
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 500, y: self.people[self.selectedCardCount].center.y)
            self.resetCard()
        })
        likeImageView.alpha = 0
        selectedCardCount += 1
        if selectedCardCount >= people.count{
            performSegue(withIdentifier: "pushList", sender: self)
        }
    }
    
    
    
}


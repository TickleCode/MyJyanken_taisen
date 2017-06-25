//
//  ViewController.swift
//  MyJanken
//
//  Created by Swift-Beginners.
//  Copyright © 2016年 Swift-Beginners. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated
  }
  
  @IBOutlet weak var answerImageView: UIImageView!
  
  @IBOutlet weak var answerLabel: UILabel!
  
  // じゃんけんのenum
  enum Jyanken : UInt32 {
    // グーの定義
    case j_gu = 0
    // チョキの定義
    case j_choki = 1
    // パーの定義
    case j_pa = 2
    
    // enumから文字列に変換
    func string() -> String {
      // じゃんけんの結果の文字を配列として定義
      let text = ["グー","チョキ","パー"]
      
      // enumの値をInt型に型変換
      let index = Int(self.rawValue)
      
      // 文字列を返す
      return text[index]
    }
    
    // enumから画像名に変換
    func imageName() -> String {
      // じゃんけんの結果の画像名を配列として定義
      let named = ["gu","choki","pa"]
      
      // enumの値をInt型に型変換
      let index = Int(self.rawValue)
      
      // 画像名を返す
      return named[index]
    }
  }
  
  // じゃんけん（Enum）
  var answerNumber:Jyanken = .j_gu
  
  @IBAction func shuffleAction(_ sender: Any) {
    
    // 新しいじゃんけんの結果を一時的に格納する変数を設ける
    // arc4random_uniform()の戻り値がUInt32なので明示的に型を指定
    var newAnswerNumber:UInt32 = 0
    
    // ランダムに結果を出すが、前回の結果と異なる場合のみ採用
    // repeat は繰り返しを意味する
    repeat {
      
      // 0,1,2の数値をランダムに算出（乱数）
      newAnswerNumber = arc4random_uniform(3)
      
      // 前回と同じ結果のときは、再度、ランダムに数値をだす
      // 異なる結果のときは、repeat を抜ける
    } while answerNumber.rawValue == newAnswerNumber
    
    // 新しいじゃんけんの結果を格納
    if newAnswerNumber == Jyanken.j_gu.rawValue {
      answerNumber = .j_gu
    } else if newAnswerNumber == Jyanken.j_choki.rawValue {
      answerNumber = .j_choki
    } else if newAnswerNumber == Jyanken.j_pa.rawValue {
      answerNumber = .j_pa
    }
    
    // じゃんけんから文字列を取り出す
    answerLabel.text = answerNumber.string()
    // じゃんけんから画像を取り出す
    answerImageView.image = UIImage(named: answerNumber.imageName())
  }
  
  @IBAction func guAction(_ sender: Any) {
    // アニメーション状態をチェック
    if animationState == .stop {
      // アニメーション停止しているので開始する
      startAnimation()
    } else if animationState == .start {
      // タップしたときのじゃんけんを覚える
      tappedJanken = .j_gu
      
      // アニメーション開始しているので停止する
      stopAnimation()
    }
  }
  
  @IBAction func chokiAction(_ sender: Any) {
    // アニメーション状態をチェック
    if animationState == .stop {
      // アニメーション停止しているので開始する
      startAnimation()
    } else if animationState == .start {
      // タップしたときのじゃんけんを覚える
      tappedJanken = .j_choki
      
      // アニメーション開始しているので停止する
      stopAnimation()
    }
  }
  
  @IBAction func paAction(_ sender: Any) {
    // アニメーション状態をチェック
    if animationState == .stop {
      // アニメーション停止しているので開始する
      startAnimation()
    } else if animationState == .start {
      // タップしたときのじゃんけんを覚える
      tappedJanken = .j_pa
      
      // アニメーション開始しているので停止する
      stopAnimation()
    }
  }
  
  // アニメーションの状態を表すenum
  enum Jotai : Int {
    // アニメーション中
    case start
    // アニメーション停止中
    case stopping
    // アニメーション停止
    case stop
  }
  
  // アニメーションの状態を管理する変数
  var animationState : Jotai = .stop
  
  // タイマーの変数を作成
  var jTimer : Timer?
  
  // タップしたじゃんけん
  var tappedJanken:Jyanken = .j_gu
  
  // じゃんけんを次々変わるアニメーションを開始する
  func startAnimation() {
    // timerをアンラップしてnowTimerに代入
    if let nowTimer = jTimer {
      // もしタイマーが、実行中だったらスタートしない
      if nowTimer.isValid == true {
        // 何も処理しない
        return
      }
    }
    
    // タイマーをスタート
    jTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                 target: self,
                                 selector: #selector(self.timerInterrupt(_:)),
                                 userInfo: nil,
                                 repeats: true)
    
    // 状態をアニメーション中に変更する
    animationState = .start
  }
  
  // じゃんけんを次々変わるアニメーションを停止する
  func stopAnimation() {
    if animationState == .start {
      // 状態を停止中に変更する
      animationState = .stopping
    }
  }

  func timerInterrupt(_ timer:Timer) {
    // 新しいじゃんけんの結果を一時駅に格納する変数を設ける
    var newAnswerNumber:UInt32 = 0
    
    // ランダムに結果を出すが前回の結果と異なる場合のみ採用する
    // repeat は繰り返しを意味する
    repeat {
      // じゃんけん結果をランダムに算出（乱数）
      newAnswerNumber = arc4random_uniform(3)
      
      // 前回と同じ結果ときは、再度、ランダムにじゃんけん結果をだす
      // 異なる結果のときは、 repeat を抜ける
    } while answerNumber.rawValue == newAnswerNumber
    
    // 新しいじゃんけんの結果を格納
    if (newAnswerNumber == Jyanken.j_gu.rawValue) {
      answerNumber = .j_gu
    } else if (newAnswerNumber == Jyanken.j_choki.rawValue) {
      answerNumber = .j_choki
    } else if (newAnswerNumber == Jyanken.j_pa.rawValue) {
      answerNumber = .j_pa
    }
    
    // じゃんけんから文字列を取り出す
    answerLabel.text = answerNumber.string()
    // じゃんけんから画像を取り出す
    answerImageView.image = UIImage(named: answerNumber.imageName())
    
    if animationState == .stopping {
      // タイマー停止
      timer.invalidate()
      // 状態を停止に変更する
      animationState = .stop
      
      // 対戦結果の初期値は"負け"
      var kekkaText : String = "負け"
      
      if answerNumber == tappedJanken {
        // 同じ内容なら"あいこ"
        kekkaText = "あいこ"
      } else if (answerNumber == .j_gu) {
        if (tappedJanken == .j_pa) {
          kekkaText = "勝ち"
        }
      } else if (answerNumber == .j_choki) {
        if (tappedJanken == .j_gu) {
          kekkaText = "勝ち"
        }
      } else if (answerNumber == .j_pa) {
        if (tappedJanken == .j_choki) {
          kekkaText = "勝ち"
        }
      }
      // 対戦結果を表示する
      answerLabel.text = "\(answerNumber.string()) \(kekkaText)"
    }
  }
}

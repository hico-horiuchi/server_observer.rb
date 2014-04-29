alert2chatwork.rb
=================
サーバーをIPアドレスとポートの組合せで監視し，Pingが通らない場合は[ChatWork](http://chatwork.com/ja/)にメッセージを送信します．

初回起動時
----------
    $ gem install bundler
    $ bundle install --path=vendor/bundler

使用方法
--------
    $ ./alert2chatwork.rb

設定
----
+ config.yml
  - `api`: ChatWorkのAPI．利用申請は[チャットワークAPI（プレビュー版）お申し込み](https://www.chatwork.com/service/packages/chatwork/subpackages/api/apply_beta.php)
  - `room_id`: 警告を送信するChatWrokのルームID(URLの`#!rid`以下の数字)．
+ list.yml
  - `ip_address`: 監視するサーバのIPアドレスまたはFQDN．
  - `servises`: 監視するサーバのポート番号またはサービス名(net-pingが対応しているもののみ)．

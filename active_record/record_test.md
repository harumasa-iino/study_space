# トピック
ActiveRecordの操作10本ノック

### 課題

#### クライアント 『IDが2の店舗に所属するスタッフって誰だっけ？』
```
irb(main):005:0> Staff.where(store_id: 2)
  Staff Load (6.0ms)  SELECT `staff`.* FROM `staff` WHERE `staff`.`store_id` = 2
+----------+------------+-----------+------------+---------+------------------------------+----------+--------+----------+----------+-------------------------+
| staff_id | first_name | last_name | address_id | picture | email                        | store_id | active | username | password | last_update             |
+----------+------------+-----------+------------+---------+------------------------------+----------+--------+----------+----------+-------------------------+
| 2        | Jon        | Stephens  | 4          |         | Jon.Stephens@sakilastaff.com | 2        | true   | Jon      |          | 2006-02-15 03:57:16 UTC |
+----------+------------+-----------+------------+---------+------------------------------+----------+--------+----------+----------+-------------------------+
1 row in set
```
#### クライアント 『映画「BLANKET BEVERLY」のDVD、いくつ在庫あるっけ？』
```
irb(main):011:0> Film.joins(:inventories).where(title: 'BLANKET BEVERLY').size
  Film Count (6.5ms)  SELECT COUNT(*) FROM `film` INNER JOIN `inventory` ON `inventory`.`film_id` = `film`.`film_id` WHERE `film`.`title` = 'BLANKET BEVERLY'
=> 4
```
解答例
```
# 自然な書き方（SQLが2回走る）

irb(main):051:0> Film.find_by(title: "BLANKET BEVERLY").inventories.size
  Film Load (0.3ms)  SELECT `film`.* FROM `film` WHERE `film`.`title` = 'BLANKET BEVERLY' LIMIT 1
   (0.2ms)  SELECT COUNT(*) FROM `inventory` WHERE `inventory`.`film_id` = 80
=> 4

# SQLが2回走るのを嫌う場合

irb(main):062:0> Inventory.joins(:film).where(film: { title: "BLANKET BEVERLY" }).size
   (0.4ms)  SELECT COUNT(*) FROM `inventory` INNER JOIN `film` ON `film`.`film_id` = `inventory`.`film_id` WHERE `film`.`title` = 'BLANKET BEVERLY'
=> 4
```
#### クライアント 『2005年に貸し出ししてるけどまだ返却されてない映画があるらしい。その映画の一覧を出して！』
- selectする場合は''で囲む
- left_joinsする場合は(table1: :table2)でできる
- 日付はDateクラスを.newで作成することで使える
```
irb(main):056:0> Film.select('film_id','title').left_joins(inventories: :rentals).where(rental: { return_date: [nil,''], rental_date: Date.new(2005)..Date.new(2005,12,31) })
  Film Load (70.6ms)  SELECT `film`.`film_id`, `film`.`title` FROM `film` LEFT OUTER JOIN `inventory` ON `inventory`.`film_id` = `film`.`film_id` LEFT OUTER JOIN `rental` ON `rental`.`inventory_id` = `inventory`.`inventory_id` WHERE (`rental`.`return_date` = NULL OR `rental`.`return_date` IS NULL) AND `rental`.`rental_date` BETWEEN '2005-01-01' AND '2005-12-31'
+---------+------------------+
| film_id | title            |
+---------+------------------+
| 1       | ACADEMY DINOSAUR |
+---------+------------------+
1 row in set
```
#### クライアント 『どんなカテゴリが売れてるんだろ？カテゴリごとに売上を集計して上位5つ教えてください！』
- left_joinsはmodelのアソシエーションを参考に単数テーブルか複数テーブルか判断する
```
irb(main):086:0> Category.joins(film_categories: { film: { inventories: { rentals: :payments } } }).select('category.category_id,name, SUM(payment.amount) AS revenue').group('cat
egory_id').order(revenue: :desc).limit(5)
  Category Load (410.7ms)  SELECT category.category_id,name, SUM(payment.amount) AS revenue FROM `category` INNER JOIN `film_category` ON `film_category`.`category_id` = `category`.`category_id` INNER JOIN `film` ON `film`.`film_id` = `film_category`.`film_id` INNER JOIN `inventory` ON `inventory`.`film_id` = `film`.`film_id` INNER JOIN `rental` ON `rental`.`inventory_id` = `inventory`.`inventory_id` INNER JOIN `payment` ON `payment`.`rental_id` = `rental`.`rental_id` GROUP BY `category`.`category_id` ORDER BY `revenue` DESC LIMIT 5
+-------------+-----------+---------+
| category_id | name      | revenue |
+-------------+-----------+---------+
| 15          | Sports    | 5314.21 |
| 14          | Sci-Fi    | 4756.98 |
| 2           | Animation | 4656.3  |
| 7           | Drama     | 4587.39 |
| 5           | Comedy    | 4383.58 |
+-------------+-----------+---------+
5 rows in set
```

### 参考サイト
- [Active Recordのメソッドと実行されるSQL一覧](https://zenn.dev/akhmgc/articles/037777478e8d1b)
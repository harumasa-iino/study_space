# トピック
ActiveRecordの操作10本ノック

### 課題

#### 課題1 クライアント 『IDが2の店舗に所属するスタッフって誰だっけ？』
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
#### 課題2 クライアント 『映画「BLANKET BEVERLY」のDVD、いくつ在庫あるっけ？』
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
#### 課題3 クライアント 『2005年に貸し出ししてるけどまだ返却されてない映画があるらしい。その映画の一覧を出して！』
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
#### 課題4 クライアント 『どんなカテゴリが売れてるんだろ？カテゴリごとに売上を集計して上位5つ教えてください！』
- left_joinsはmodelのアソシエーションを参考に単数テーブルか複数テーブルか判断する
```
irb(main):086:0> Category.joins(film_categories: { film: { inventories: { rentals: :payments } } }).select('category.category_id,name, SUM(payment.amount) AS revenue').group('category_id').order(revenue: :desc).limit(5)
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
#### 課題5 クライアント 『どんなカテゴリの映画が多いんだろ？カテゴリ別に映画の本数を集計して、60本以上あるものを全部出して欲しい！』
```
irb(main):100:0> Category.left_joins(film_categories: :film).select('category.category_id,name,COUNT(DISTINCT film.title) AS number_of_film').group('category.category_id').order(
number_of_film: :desc).having("number_of_film>=60")
  Category Load (29.9ms)  SELECT category.category_id,name,COUNT(DISTINCT film.title) AS number_of_film FROM `category` LEFT OUTER JOIN `film_category` ON `film_category`.`category_id` = `category`.`category_id` LEFT OUTER JOIN `film` ON `film`.`film_id` = `film_category`.`film_id` GROUP BY `category`.`category_id` HAVING (number_of_film>=60) ORDER BY `number_of_film` DESC
+-------------+-------------+----------------+
| category_id | name        | number_of_film |
+-------------+-------------+----------------+
| 15          | Sports      | 74             |
| 9           | Foreign     | 73             |
| 8           | Family      | 69             |
| 6           | Documentary | 68             |
| 2           | Animation   | 66             |
| 1           | Action      | 64             |
| 13          | New         | 63             |
| 7           | Drama       | 62             |
| 14          | Sci-Fi      | 61             |
| 10          | Games       | 61             |
| 3           | Children    | 60             |
+-------------+-------------+----------------+
11 rows in set
```
解答例  
- filmテーブルは単数でuniqueのnameが入っているテーブルなのでcount(*)で良かった
- groupする際はいくつかのカラムで行ったほうが良い
- havingしてからorderのほうがデータ処理が軽そう
```
Category.select("category.category_id, name, count(*) as number_of_film").joins(:film_categories).group(:category_id, :name).having("number_of_film >= 60").order("number_of_film desc")
```

#### 課題6 クライアント 『JOE SWANKが出演してる映画全部見たいから教えて！』
```
irb(main):116:0> Film.select("film.film_id,title").left_joins(film_actors: :actor).where(actor: {first_name: "JOE",last_name:"SWANK"})
  Film Load (11.3ms)  SELECT film.film_id,title FROM `film` LEFT OUTER JOIN `film_actor` ON `film_actor`.`film_id` = `film`.`film_id` LEFT OUTER JOIN `actor` ON `actor`.`actor_id` = `film_actor`.`actor_id` WHERE `actor`.`first_name` = 'JOE' AND `actor`.`last_name` = 'SWANK'
+---------+------------------------+
| film_id | title                  |
+---------+------------------------+
| 30      | ANYTHING SAVANNAH      |
| 74      | BIRCH ANTITRUST        |
| 147     | CHOCOLAT HARRY         |
| 148     | CHOCOLATE DUCK         |
| 191     | CROOKED FROGMEN        |
| 200     | CURTAIN VIDEOTAPE      |
| 204     | DALMATIONS SWEDEN      |
| 434     | HORROR REIGN           |
| 510     | LAWLESS VISION         |
| 514     | LEBOWSKI SOLDIERS      |
| 552     | MAJESTIC FLOATS        |
| 650     | PACIFIC AMISTAD        |
| 671     | PERDITION FARGO        |
| 697     | PRIMARY GLASS          |
| 722     | REEF SALUTE            |
| 752     | RUNNER MADIGAN         |
| 811     | SMILE EARRING          |
| 815     | SNATCHERS MONTEZUMA    |
| 865     | SUNRISE LEAGUE         |
| 873     | SWEETHEARTS SUSPECTS   |
| 889     | TIES HUNGER            |
| 903     | TRAFFIC HOBBIT         |
| 926     | UNTOUCHABLES SUNRISE   |
| 964     | WATERFRONT DELIVERANCE |
| 974     | WILD APOLLO            |
+---------+------------------------+
25 rows in set
```
解答例
- throughのアソシエーションがあれば中間テーブルを省いてjoinしてもSQLがちゃんと発行される
```
Film.joins(:actors).where(actor: { first_name: "JOE", last_name: "SWANK" }).select(:film_id, :title)
```

#### 課題7 クライアント 『短い映画は見応えがないな...JOE SWANKが出演している映画の中でも100分以上放映時間があるものだけ見せて！』
```

irb(main):129:0> Film.joins(:actors).where(actor: { first_name: "JOE", last_name: "SWANK" }).where("length>=100").select(:film_id, :title, :length)
  Film Load (9.9ms)  SELECT `film`.`film_id`, `film`.`title`, `film`.`length` FROM `film` INNER JOIN `film_actor` ON `film_actor`.`film_id` = `film`.`film_id` INNER JOIN `actor` ON `actor`.`actor_id` = `film_actor`.`actor_id` WHERE `actor`.`first_name` = 'JOE' AND `actor`.`last_name` = 'SWANK' AND (length>=100)                                            
+---------+----------------------+--------+
| film_id | title                | length |
+---------+----------------------+--------+
| 74      | BIRCH ANTITRUST      | 162    |
| 147     | CHOCOLAT HARRY       | 101    |
| 148     | CHOCOLATE DUCK       | 132    |
| 191     | CROOKED FROGMEN      | 143    |
| 200     | CURTAIN VIDEOTAPE    | 133    |
| 204     | DALMATIONS SWEDEN    | 106    |
| 434     | HORROR REIGN         | 139    |
| 510     | LAWLESS VISION       | 181    |
| 552     | MAJESTIC FLOATS      | 130    |
| 650     | PACIFIC AMISTAD      | 144    |
| 722     | REEF SALUTE          | 123    |
| 752     | RUNNER MADIGAN       | 101    |
| 865     | SUNRISE LEAGUE       | 135    |
| 873     | SWEETHEARTS SUSPECTS | 108    |
| 889     | TIES HUNGER          | 111    |
| 903     | TRAFFIC HOBBIT       | 139    |
| 926     | UNTOUCHABLES SUNRISE | 120    |
| 974     | WILD APOLLO          | 181    |
+---------+----------------------+--------+
```

#### 課題8 クライアント 『Action系の映画が見たい！JOE SWANKが出演してる映画でActionカテゴリに分類されるものを取ってきて！』
```
irb(main):131:0> Film.joins(:actors, :categories).where(actor: { first_name: "JOE", last_name: "SWANK" }).where(category: {name: "Action"}).select(:film_id, :title)
  Film Load (20.0ms)  SELECT `film`.`film_id`, `film`.`title` FROM `film` INNER JOIN `film_actor` ON `film_actor`.`film_id` = `film`.`film_id` INNER JOIN `actor` ON `actor`.`actor_id` = `film_actor`.`actor_id` INNER JOIN `film_category` ON `film_category`.`film_id` = `film`.`film_id` INNER JOIN `category` ON `category`.`category_id` = `film_category`.`category_id` WHERE `actor`.`first_name` = 'JOE' AND `actor`.`last_name` = 'SWANK' AND `category`.`name` = 'Action'
+---------+------------------------+
| film_id | title                  |
+---------+------------------------+
| 697     | PRIMARY GLASS          |
| 964     | WATERFRONT DELIVERANCE |
+---------+------------------------+
2 rows in set
```
#### 課題9 クライアント 『JOE SWANKが出演している映画の中で特に人気なのはどれだろ？売れてるランキングトップ10を見せて！』
```
irb(main):139:0> Film.joins(:actors, inventories: { rentals: :payments}).select("film.film_id, title, SUM(payment.amount) AS revenue").where(actor: { first_name: "JOE", last_name
: "SWANK" }).group('film_id').order(revenue: :desc).limit(10)
  Film Load (32.6ms)  SELECT film.film_id, title, SUM(payment.amount) AS revenue FROM `film` INNER JOIN `film_actor` ON `film_actor`.`film_id` = `film`.`film_id` INNER JOIN `actor` ON `actor`.`actor_id` = `film_actor`.`actor_id` INNER JOIN `inventory` ON `inventory`.`film_id` = `film`.`film_id` INNER JOIN `rental` ON `rental`.`inventory_id` = `inventory`.`inventory_id` INNER JOIN `payment` ON `payment`.`rental_id` = `rental`.`rental_id` WHERE `actor`.`first_name` = 'JOE' AND `actor`.`last_name` = 'SWANK' GROUP BY `film`.`film_id` ORDER BY `revenue` DESC LIMIT 10
+---------+------------------------+---------+
| film_id | title                  | revenue |
+---------+------------------------+---------+
| 865     | SUNRISE LEAGUE         | 170.76  |
| 964     | WATERFRONT DELIVERANCE | 121.83  |
| 873     | SWEETHEARTS SUSPECTS   | 98.71   |
| 434     | HORROR REIGN           | 87.73   |
| 510     | LAWLESS VISION         | 86.84   |
| 889     | TIES HUNGER            | 80.89   |
| 74      | BIRCH ANTITRUST        | 74.89   |
| 514     | LEBOWSKI SOLDIERS      | 72.79   |
| 650     | PACIFIC AMISTAD        | 62.76   |
| 811     | SMILE EARRING          | 58.9    |
+---------+------------------------+---------+
10 rows in set
```
解説
- limitは先に行う
```
Film.select("film.film_id, film.title, sum(payment.amount) as revenue").joins(:actors, inventories: { rentals: :payments }).where(actor: { first_name: "JOE", last_name: "SWANK" }).limit(10).group(:film_id).order(revenue: :desc)
```
#### 課題10　クライアント 『SUNRISE LEAGUEっていう映画がおもろいらしい。どれくらい売上あるんだろ？』
```
irb(main):143:0> Film.joins(inventories: { rentals: :payments}).select('film.film_id, title, SUM(payment.amount) AS revenue').where(title: 'SUNRISE LEAGUE').group('film_id')
  Film Load (9.2ms)  SELECT film.film_id, title, SUM(payment.amount) AS revenue FROM `film` INNER JOIN `inventory` ON `inventory`.`film_id` = `film`.`film_id` INNER JOIN `rental` ON `rental`.`inventory_id` = `inventory`.`inventory_id` INNER JOIN `payment` ON `payment`.`rental_id` = `rental`.`rental_id` WHERE `film`.`title` = 'SUNRISE LEAGUE' GROUP BY `film`.`film_id`
+---------+----------------+---------+
| film_id | title          | revenue |
+---------+----------------+---------+
| 865     | SUNRISE LEAGUE | 170.76  |
+---------+----------------+---------+
1 row in set
```

### 参考サイト
- [Active Recordのメソッドと実行されるSQL一覧](https://zenn.dev/akhmgc/articles/037777478e8d1b)
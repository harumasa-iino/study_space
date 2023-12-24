# トピック
アクション権限の調整

## 目標
ライター権限ではタグ・著者・カテゴリーの作成ができないが編集・削除ができてしまう、また権限が許可されていないページにアクセスした際にサーバーエラーが出てしまう  
ライター権限ではタグ・著書・カテゴリーの一覧表示・編集・削除を出来ないようにし、権限エラーが発生した際には403エラーのページを表示させる

## 学習内容
- Punditによる権限管理

### 課題に対しての学習内容
まずは現状の把握から  
writerでログインするとタグ・著者・カテゴリーの一覧が表示されており、編集・削除が出来る状態を確認  
カテゴリの作成を行おうとした場合にサーバーエラーが発生
```
Pundit::NotAuthorizedError in Admin::CategoriesController#create

not allowed to create? this Class

def create
  authorize(Category)

  @category = Category.new(category_params)
```
punditの権限が無いとのエラーが発生していることが分かる。controllerでauthorizeを使って権限を制限しているよう  

#### Punditについて
punditは各コントローラーの各アクションでauthorizeリソースオブジェクトを呼ぶと、対象のリソースに対して権限があるかどうかを確認する。設定は`app/policies`のポリシーファイルで細かく定義できる


設定したコントローラの各アクションでauthorizeリソースオブジェクトを呼ぶと､対象のリソースに対して権限があるかどうかを確認してくれる｡**その設定をapp/policiesにあるポリシーファイルで細かく定義できる｡

### 認可と認証について
認証は誰であるのかを確認すること。マイナンバーカードであなたは鈴木さんと確認できましたとなる  
認可はあることを許可すること、電車の切符などのイメージで、電車に乗ることが許可されているということ  
認証によって誰であるのかが分かることで認可ができるので、認可は認証に依存している

### やったこと
policyファイルでアクションごとに権限の設定
```
class TaxonomyPolicy < ApplicationPolicy
  def index?
    user.admin? || user.editor?
  end

  def create?
    user.admin? || user.editor?
  end

  def update?
    user.admin? || user.editor?
  end

  def edit?
    user.admin? || user.editor?
  end

  def destroy?
    user.admin? || user.editor?
  end
end
```
今回はタグ・カテゴリー・著者とtaxnomyを使用したモデルのため一括で設定  

#### 権限がない際に403エラーページを表示させる
public/403.htmlを作成 
```
<!DOCTYPE html>
<html>
<head>
  <title>権限がありません(401)</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
</head>

<body>
  <p>権限がありません。</p>
</body>
</html>
```
本番環境でのみ表示されるため、開発環境で確認できるようにenvironment/development.rbを編集
```
# Show full error reports. falseに設定することで開発環境で確認出来るようになる
# config.consider_all_requests_local = true
config.consider_all_requests_local = false
```
さらにエラー時に403を表示させるために下記を設定する
```
#punditでのエラーを指定。forbittenというシンボルはステータスコード403と定義されている
config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden
```

#### 苦戦したこと
通常のRspecのテストだと権限エラーが出てしまいテストができない
```
Capybara::NotSupportedByDriverError:
```
そのためHttpのステータスを取得する必要がある
```
expect(page).to have_http_status(403)
```
httpのステータスコードを取得するには下記設定が必要
```
 before do
    # avoid Capybara::NotSupportedByDriverError to use page.status_code
    driven_by(:rack_test)
  end
```
 [pundit](https://github.com/varvet/pundit?tab=readme-ov-file#rescuing-a-denied-authorization-in-rails)
development.rbにしかforbiddenの設定していなかったが、rspecの環境でも403エラーを発生させるためにapprication.rbに設定する必要があった

## 参考サイト
- [【Rails】authorizeとは？[Pundit] / 403エラー画面の作成有り](https://qiita.com/mmaumtjgj/items/c7fc40619a15cce5ccfc)
- [参考サイト2](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)
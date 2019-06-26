# React.js 超入門

原文: https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux

2015年10月

---

## Agenda

1. 概要
2. Hello world
3. デモ
4. ライフサイクルメソッド
5. Flux
6. Redux
7. まとめ

---

## 概要

[github.com/facebook/react](//github.com/facebook/react)

Facebook 製のライブラリで MVC でいうところのビューの部分

あくまでビューのライブラリであって全体のアーキテクチャを制約するものではないのでフレームワークではない

---

### 主な特長3つ

- JUST THE UI
- VirtualDOM
- DATA FLOW

---

**JUST THE UI**

* Component を作るだけに徹している
* よって覚える API や慣例も少ない
* ほかのフレームワークのビュー部分を React で作るということも可能

※ここでいう Component とは、 **見た目（CSS）と機能（JavaScript）を内包したHTMLの独自タグ** という解釈でとりあえずいいと思います

---

フレームワークやライブラリや言語によって Component という言葉が指すものが違うと思いますが、 Web フロントの Component というと W3C で策定中の Web Components 的なもの

* Shadow DOM => DOM のカプセル化
* Custom Elements => HTML 独自タグ
* HTML Imports => HTML 用 require 的な
* HTML Templates => 標準仕様 HTML テンプレート

[https://github.com/w3c/webcomponents/](https://github.com/w3c/webcomponents/)

---

**VirtualDOM**

DOM と対を成すツリー上の構造体を表したデータ（JavaScript オブジェクト）

---

雑な例

```javascript
{
  html: {
    attributes: {...},
    children: {
      head: {
        children: {
          title: 'title',
          meta: {...}
        }
      },
      body: {
        attributes: {
          className: 'body-class'
        },
        children: {
          h1: {
            textContent: 'h1',
            attributes: {...}
            children: {
              a: {
                textContent: 'link',
                attributes: {
                  href: 'url'
                }
              }
            }
          }
        }
      }
    }
  }
}
```

---

と、

それを用いた diff/patch アルゴリズムを指す

例えば

`body h1 a.link` の `href` 属性に差分が検出されると、

`document.querySelector('h1 a.link').setAttribute('href', '/new/link')`

だけが走るイメージ

---

> HTMLとはツリー構造であり、2つのツリー構造のdiffを算出して、それをDOMにpatchするアクションを作れば、常に最小のコストで状態遷移を表現できるよね、ってのがVirtual DOMという発想のスタート地点となります。

> このHTMLの生成する元となるツリー構造は、生のDOM(HTMLのインスタンス)である必要はなく、DOMと1対1に対応する単純な構造体で表現し、それを仮想DOMと呼びます。

> 単純なJSの構造体なので、基本的に仮想DOM実装はブラウザ環境である必要がなく、node.jsやピュアなV8でも仮想DOMの構築とdiff生成までは可能です。

[http://qiita.com/mizchi/items/4d25bc26def1719d52e6](http://qiita.com/mizchi/items/4d25bc26def1719d52e6)

---

**DATA FLOW**

> アプリケーションのstateを管理しているルートコンポーネントがいて、
そのstateを子のコンポーネントに流して、子のコンポーネントはそれを受け取って、レンダリングする
という、一方向なデータの流れを提供する

データの流れは一方向（単方向バインディング）

ただ、双方向バインディング（Angular とか vue とか）のように明らかにコード量が減ったりしない

データの流れを一方向にすることによって考慮することは減ってわかりやすくなる

---

### JSX

JSX という JavaScript 中に XML 的なものを書けて HTML を表現できる

```javascript
class Header extends React.Component {

  render() {
    return (
      <header className="header">
        <h1>{this.props.title}</h1>
      </header>
    );
  }

}
```

---

`render()` の部分はこうコンパイルされる

```javascript
render() {
  return React.createElement(
    'header',
    { className: 'header' },
    React.createElement('h1', null, this.props.title)
  );
}
```

[React JSFiddle](https://jsfiddle.net/reactjs/69z2wepo/)

react@v0.14.0 以前では `react-tools` というツールで JS にコンパイルしてたが、現在は [Babel](https://babeljs.io/) の利用を推奨している (`react-tools` の更新は止まる)

Babel => JavaScript のトランスパイラ

ES6について： [https://github.com/sugarshin/study-mtg/blob/master/es6/doc.md](https://github.com/sugarshin/study-mtg/blob/master/es6/doc.md)

---

### サーバサイドレンダリング

`react-dom` に React コンポーネントを HTML 文字列にして返すメソッドがある

**`require('react-dom/server').renderToString()`**

`require('react-dom/server').renderToStaticMarkup()` というのもあるけど、これは純粋な HTML 文字列が返される（React エレメントとして必要な data 属性等を含まない）

JS の評価エンジンさえあればサーバ側でレンダリングして HTML 文字列としてクライアントに返せる

なので初回アクセス時はサーバでレンダリング済みの HTML を返して、みたいなことができるので SEO 的にも、 SPA の問題としてよくあがる初回表示の遅さもなんとかなる

---

## Hello world

version

* react v16.2.0
* react-dom v16.2.0

---

```javascript
import React, { Component } from 'react';
import { render } from 'react-dom';

class Hello extends Component {
  render() {
    return <div>Hello {this.props.name}</div>;
  }
}

render(<Hello name="world" />, document.getElementById('root'));
```

[https://codepen.io/sugarshin/pen/dmRzGj](https://codepen.io/sugarshin/pen/dmRzGj)

~~`React.createClass()` に `render` メソッドをもつオブジェクトを渡すことでも作成できる~~

Deprecated + [別パッケージ](https://www.npmjs.com/package/create-react-class) になりました

---

Component のビューとロジックの密結合について

[http://qiita.com/koba04/items/4f874e0da8ebd7329701](http://qiita.com/koba04/items/4f874e0da8ebd7329701)

> ところで、React.jsではComponentとして、マークアップとViewのロジックをcreateClassの中に書いていくのですが、他のフレームワークのようにマークアップはHTMLやmustacheで書いてViewのロジックをJSで書くみたいに分かれてなくて気持ち悪い！という人もいるのではないでしょうか？
それに対して、React.jsの開発者であるPete Huntはそれは「関心の分離(Separation of concerns)」ではなくて「技術の分離(Separation of technologies)」だとしていて、マークアップとViewのロジックは密であるべきとしています。
それにTemplateのSyntaxで不自由にコードを書くよりJavaScriptで書いた方がいいとしています。
テストが...という問題は、React.jsではTestUtilsというAddonでサポートしています。

---

## デモ

### カウンター

[http://codepen.io/sugarshin/pen/RWMmQX](http://codepen.io/sugarshin/pen/RWMmQX)

[https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/counter](https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/counter)

---

```javascript
import React, { Component } from 'react';
import { render } from 'react-dom';

class Counter extends Component {

  constructor() {
    super();

    // 初期state（状態）をここで定義
    // `create-react-class` でコンポーネントを作る場合の `getInitialState()` と同義
    this.state = {
      count: 0
    };
  }

  render() {
    // ~~必ず1つのコンポーネント（HTML）を返すようにする~~
    // v16 から配列でも返せるようになった
    // return [
    //   <div key='foo'>foo</div>,
    //   <div key='bar'>bar</div>,
    // ]
    return (
      <div>
        // `{}` は JavaScript の式として評価してくれる
        <span>{this.state.count}</span>
        // DOM のイベントは 'on + イベント名' でハンドリングする
        <button onClick={::this.handleClickUp}>Count up</button>
        <button onClick={::this.handleClickDown}>Count down</button>
      </div>
    );
  }

  handleClickUp() {
    // `setState()` で自身の状態を更新する
    // `this.state` を直接触らない
    this.setState({ count: this.state.count + 1 });
  }

  handleClickDown() {
    this.setState({ count: this.state.count - 1 });
  }

}

// 第1引数にマウントするコンポーネント、第2引数にマウント先の DOM の参照を渡してレンダリング
render(<Counter />, document.getElementById('root'));
```

---

* ~~1つのコンポーネントを返す~~
* `state` で自身の状態を保持できる
* `setState()` で `state` を更新すると `render()` が走ってレンダリングしてくれる
* `props` で外部とやりとりもできる

---

### Stateless Component

react@v0.14 から `state` を持たない、 `props` だけに依存するようなコンポーネントの新しい定義の仕方ができるようになった

---

```javascript
import React from 'react';
import PropTypes from 'prop-types';

// コンポーネントを返すだけの関数として定義
// 引数に `props` が渡ってくる
export default function Footer(props) {
  return <footer>{props.copyright}</footer>;
}

// propTypes や defaultProps も
// 関数のプロパティとして定義できる
Footer.propTypes = {
  copyright: PropTypes.string.isRequired
};

render(<Footer copyright="@sugarshin" />, document.getElementById('id'));
```

---

ライフサイクルメソッドは利用できない

react@v0.15 ではパフォーマンス改善等のリリースになるようで、この Stateless Component の書き方で書いておくとパフォーマンスの支援を受けられる

今後はこの方法を主に使っていくことになると思う

---

### Todoアプリ

簡単な Todo アプリのデモ

[http://codepen.io/sugarshin/pen/dYmZgN](http://codepen.io/sugarshin/pen/dYmZgN)

[https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/todo](https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/todo)

---

Todoコンポーネント

```javascript
import React, { Component } from 'react';
import PropTypes from 'prop-types';

export default class Todo extends Component {

  // 外部から受け取る`props`に対してそれぞれのランタイムチェックをスタティックプロパティとして定義できる
  // エラーは投げられず、 Warning になるのみ
  // Production 環境では無視される
  static propTypes = {
    id: PropTypes.number.isRequired,
    text: PropTypes.string.isRequired,
    complete: PropTypes.bool.isRequired,
    onClickCheckbox: PropTypes.func.isRequired,
    onClickDelete: PropTypes.func.isRequired
  };

  render() {
    const { complete, text } = this.props;

    // ~~必ず1つのコンポーネント（html）を返す~~
    return (
      // インライン CSS は `style` 属性にオブジェクトを渡す
      <div
        style={{
          opacity: complete ? .5 : 1,
          textDecoration: complete ? 'line-through' : 'none'
        }}
      >
        // 各 DOM のイベントは `on + イベント名` みたいは感じでハンドリングする
        <input type="checkbox" checked={complete} onChange={::this.handleClickCheckbox} />
        <span>{text}</span>
        <button onClick={::this.handleClickDelete}>Delete</button>
      </div>
    );
  }

  // propsとして外部（親）から渡された関数を実行
  handleClickCheckbox() {
    this.props.onClickCheckbox(this.props.id);
  }

  handleClickDelete() {
    this.props.onClickDelete(this.props.id);
  }

}
```

---

AddTodo ボタンコンポーネント

```javascript
import React, { Component } from 'react';

export default class AddTodo extends Component {

  static propTypes = {
    onClickAdd: PropTypes.func.isRequired
  };

  render() {
    return (
      <div>
        // `ref` 属性を指定しておくと同コンポーネントから`this.refs[名前]`で参照できる
        <input type="text" ref="input" placeholder="Todo name" />
        <button onClick={::this.handleClickButtonAdd}>Add</button>
      </div>
    );
  }

  handleClickButtonAdd() {
    this.props.onClickAdd(this.refs.input.value);
  }

}
```

---

TodoListコンポーネント

```javascript
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Todo from './Todo';

export default class TodoList extends Component {

  static propTypes = {
    todos: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number,
      text: PropTypes.string,
      complete: PropTypes.bool
    })).isRequired,
    onClickDelete: PropTypes.func.isRequired,
    onClickCheckbox: PropTypes.func.isRequired
  };

  render() {
    return (
      // 配列もうまく展開してくれる
      <div>{this.renderTodos()}</div>
    );
  }

  renderTodos() {
    const { onClickDelete, onClickCheckbox, todos } = this.props;
    return todos.map(todo => (
      // `key` 属性に一意の値を渡す
      // 必須ではないけど Warning がでる、 diff/patch 処理が遅くなる
      <Todo
        key={todo.id}
        onClickDelete={onClickDelete}
        onClickCheckbox={onClickCheckbox}
        { ...todo }
      />
    ));
  }

}
```

---

Appコンポーネント

全体をラップしてstateを保持し、子コンポーネントに流す

状態を変更する関数も渡す

---

```javascript
import React, { Component } from 'react';

import TodoList from './TodoList';
import AddTodo from './AddTodo';

export default class App extends Component {

  constructor() {
    super();
    this.state = {
      todos: []
    };
  }

  render() {
    return (
      <div>
        // propsとして各 DOM イベントのコールバックを渡す
        <AddTodo onClickAdd={::this.addTodo} />
        <TodoList
          todos={this.state.todos}
          onClickDelete={::this.deleteTodo}
          onClickCheckbox={::this.changeComplete}
        />
      </div>
    );
  }

  addTodo(text) {
    this.setState({
      todos: [...this.state.todos, {
        id: Date.now(),
        complete: false,
        text
      }]
    });
  }

  deleteTodo(id) {
    this.setState({
      todos: this.state.todos.filter(todo => todo.id !== id)
    });
  }

  changeComplete(id) {
    this.setState({
      todos: this.state.todos.map(todo => {
        if (todo.id === id) {
          todo.complete = !todo.complete;
        }
        return todo;
      })
    });
  }

}
```

---

実行部分

```javascript
import React from 'react';
import { render } from 'react-dom';
import App from './App';

// 第2引数にマウント先のDOMを指定
render(<App />, document.getElementById('root'));
// document.bodyを指定すると Warning でるようになった
```

[http://codepen.io/sugarshin/pen/dYmZgN](http://codepen.io/sugarshin/pen/dYmZgN)

[https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/todo](https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/todo)

---

## ライフサイクルメソッド

コンポーネントの状態の変化や適切なタイミングで呼ばれる決まったメソッドがある

例えば、

* DOM に追加されたとき、される直前
* render が走ったあと
* props が更新される前

などなど

[http://qiita.com/koba04/items/66e9c5be8f2e31f28461](http://qiita.com/koba04/items/66e9c5be8f2e31f28461)

---

```javascript
class Button extends Component {

  componentDidMount() {
    ...
  }

  componentDidUpdate() {
    ...
  }

  render() {
    return <button>Button</button>;
  }

}
```

---

よくやる例としては、

`componentDidMount()` でコンポーネントがDOMに追加されたあとにイベントリスナを登録し、 `componentWillUnmount()` でコンポーネントが DOM から削除される直前にイベントリスナを解除する、みたいなメモリリーク対策

---

`shouldComponentUpdate()`

パフォーマンス対策に利用

`true` か `false` を返す

`false` だと diff/patch 処理が行われなくなる

デフォルトは `true`

無駄な計算や処理を削減しパフォーマンス向上をはかれる

[http://qiita.com/koba04/items/66e9c5be8f2e31f28461#shouldcomponentupdate](http://qiita.com/koba04/items/66e9c5be8f2e31f28461#shouldcomponentupdate)

---

## Flux

React とペアでよく話されるアーキテクチャのこと

実装ではなくあくまでアーキテクチャの話

[http://facebook.github.io/flux/](http://facebook.github.io/flux/)

一応謹製の実装もある

[https://github.com/facebook/flux](https://github.com/facebook/flux)

---

React を効率よく利用するために Facebook が提唱したもの

MVC アーキテクチャの改変版的な

ただの Observer パターン（Pub Subパターン）=> Node でいうところの EventEmitter みたいなもの

Facebook は「MVCはスケールしない」みたいに言ってるけど結局オレオレ MVC みたいなものだと思う

※ここでいう MVC はWebサーバ等の MVC ではなくて、 Smalltalk MVC など GUI 構築のための MVC のこと

> モデル - 問題対象としてのデータとそのデータに対する操作。

> ビュー - ディスプレイを通して、モデルからユーザへ情報を提供するもの。

> コントローラ - ユーザからの入力を解釈して、モデルあるいはビューに適切な調整を施すもの。

[http://www.cdl.im.dendai.ac.jp/~masuda/mvc.html](http://www.cdl.im.dendai.ac.jp/~masuda/mvc.html)

---

よく見る図

![Flux](https://raw.githubusercontent.com/facebook/flux/master/docs/img/flux-diagram-white-background.png)

**Flux　の最も優れている点は上記に「Flux」と名前をつけたところ**

---

オレオレFlux乱立

各種実装

* [https://github.com/facebook/flux](https://github.com/facebook/flux)
* [https://github.com/BinaryMuse/fluxxor](https://github.com/BinaryMuse/fluxxor)
* [https://github.com/azu/material-flux](https://github.com/azu/material-flux)
* [https://github.com/reflux/refluxjs](https://github.com/reflux/refluxjs)
* [https://github.com/yahoo/fluxible](https://github.com/yahoo/fluxible)
* [https://github.com/mizchi/arda](https://github.com/mizchi/arda)
* [https://github.com/rackt/redux/](https://github.com/rackt/redux/)

---

**データの流れは常に一方向**

これにより React と相性が良い

主な層は

* ActionCreator => アクション（だいたいの場合 `type` キーとそのアクションごとのデータをもったオブジェクト）を作って Dispatcher に送る
* Dispatcher => 受けたアクションを Store へ送る
* Store => 送られてきたアクションを元に自身の State（アプリケーションの状態）を更新
* View (React) => Store を listen しておいて、更新を検知し、適宜レンダリング
  * DOM イベント等を通じて ActionCreator を通してアクションを生成

という、一方向サイクル

---

### 簡単な Flux 実装の例

データの流れが一方向、というのがポイントの1つなので、それを簡単に再現

ここでは `Dispatcher` は `EventEmitter` と考えます

---

イメージ

```
[View] DOMイベント等からアクションを呼ぶ ------> [ActionCreator] 適切なアクションを作ってStoreへ通知
                                               |
ViewはStoreを監視しておいて変更があるとレンダリング   |
  |                                            |
  ----------------------------------------- [Store] 受け取ったアクションを元に自身を更新
```

それぞれの架け渡し的な存在が Dispatcher (EventEmitter)

---

Store層

```javascript
import { EventEmitter } from 'events';

class Store extends EventEmitter {

  constructor(dispatcher) {
    super();

    // stateの初期化　これがアプリケーションの状態
    this.state = { count: 0 };

    // dispatcherを受け取ってそれぞれのアクションの名前にリスナを登録
    dispatcher.on('countup', ::this.onCountUp);
    dispatcher.on('countdown', ::this.onCountDown);
  }

  // 外部からstateにアクセスできるようにしておく
  getState() {
    return this.state;
  }

  // 'countup'アクションが渡ってきたとき（'countup'イベントがemitされたとき）のコールバック
  // 同時に 'CHANGE' イベントをemitする
  // listenしてるView（React）にstateが更新されたことが通知される
  onCountUp(count) {
    this.state = { count: this.state.count + count };
    this.emit('CHANGE');
  }

  onCountDown(count) {
    this.state = { count: this.state.count - count };
    this.emit('CHANGE');
  }

}

```

---

EventEmitterの実装例

```javascript
class EventEmitter {
  constructor() {
    this.events = {};
  }

  on(name, listener) {
    this.events[name] = this.events[name] || [];
    this.events[name] = [...this.events[name], listener];
  }

  off(name, listener) {
    if (listener) {
      this.events[name] = this.events[name].filter(l => l !== listener);
    } else {
      delete this.events[name];
    }
  }

  emit(name, ...args) {
    this.events[name].forEach(listener => listener(...args));
  }
}

const emitter = new EventEmitter();

emitter.on('some', () => console.log('hoge'));
emitter.emit('some'); // => 'hoge'
```

ここでは Node.js の `require('events').EventEmitter` を使います

---

Action Creator

```javascript
class ActionCreator {

  // Storeと同じdispatcherを受け取る
  constructor(dispatcher) {
    this.dispatcher = dispatcher;
  }

  // Viewから呼ばれるアクションたち
  // 'countup'イベントをemit
  countUp(count) {
    this.dispatcher.emit('countup', count);
  }

  countDown(count) {
    this.dispatcher.emit('countdown', count);
  }

}
```

---

```javascript
import React, { Component } from 'react';

// Dispatcher
const dispatcher = new EventEmitter();

const action = new ActionCreator(dispatcher);
const store = new Store(dispatcher);

class Counter extends Component {

  constructor() {
    super();

    // `state`の初期値をstoreから`getState`してとってくる
    const { count } = store.getState();
    this.state = { count };

    // `store`が更新されたとき（'CHANGE'イベントがemitされたとき）のコールバックをここで登録
    store.on('CHANGE', ::this.onChangeState);
  }

  render() {
    return (
      <div>
        <span>{this.state.count}</span>
        <button onClick={::this.handleClickUp}>Count up</button>
        <button onClick={::this.handleClickDown}>Count down</button>
        <select defaultValue="1" ref="rate">
          <option value="1">1</option>
          <option value="10">10</option>
        </select>
      </div>
    );
  }

  // `store`が更新されると呼ばれて`setState()`してレンダリングする
  onChangeState() {
    const { count } = store.getState();
    this.setState({ count });
  }

  // クリックイベントでアクションを呼ぶ
  handleClickUp() {
    action.countUp(+this.refs.rate.value);
  }

  handleClickDown() {
    action.countDown(+this.refs.rate.value);
  }

}

```

---

View のカウントアップボタンクリック -> Action Creator を呼ぶ ->

Action Creator は指定のイベントを emit して Store に通知 ->

Store は通知を受け取って state を更新して、更新されたことを外部に通知 ->

View は Store の更新通知を受け取って、 state を取得してそれを元にレンダリング

**流れが一方向** View が直接 Store の state を更新したりしない

[https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/flux](https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/flux)

---

## Redux

[https://github.com/rackt/redux](https://github.com/rackt/redux)

* Flux の仲間
* 作者は Flux であって Flux ではないって言ってる
* ヨーロッパの React カンファレンス2015で作者が登壇して Redux について発表 [https://www.youtube.com/watch?v=xsSnOQynTHs](https://www.youtube.com/watch?v=xsSnOQynTHs)
* Flux 実装で今一番盛り上がってる
* 日本だとまだあまり盛り上がってないかも
* もう Flux これでいいんじゃないの的な雰囲気
* 少なくてもぼくはこれ使っていこうと思ってます

docs: [http://redux.js.org/](http://redux.js.org/)

作者：

[https://github.com/gaearon](https://github.com/gaearon)

[https://twitter.com/dan_abramov](https://twitter.com/dan_abramov)

最近 Facebook にジョインしたらしい

---

### 特長

* １つのオブジェクト (JSON) でアプリケーション全体の状態を管理する
* シンプル 内部実装が読める
* ドキュメントが電子ブック形式でチュートリアル形式でわかりやすい
* Hot reloading
* Reducer
* Middleware
* Action や Reducer (Store的な部分)が純粋な関数なのでテストもしやすい

**Redux == Reducers + Flux**

ちょっと前まで人気あった Flummox という Flux 実装のフレームワークの作者が Redux 最高って言い出して、もう Flummox 更新しません、Redux 使いましょうってなって今や Redux 周りのユーティリティとか作ってる

---

### 作った目的

そもそもの目的は Hot reloading を簡単に可能にしたいというのが発端

**Hot reloading**

コードを編集してリロードしても前の状態を維持したまま一部のコンポーネントを更新する

例えば、モーダルが開いてる状態のときの何かをデバッグしたい

コードを編集 => リロード => モーダルを開く => 確認 =>

コードを編集 => リロード => モーダルを開く => 確認 =>

毎回モーダルを開かないといけない（リロードされるので当たり前）

作者はこれが許せないらしく Hot reloading 大好き

これを既存の Flux 実装の中でやろうとすると難しいらしい

これが Redux を作った経緯

で、作ってみたらいろいろ良いところがあった

---

### API

5つのみ

* `createStore`
  * `reducer` を受け取って store を作る
* `combineReducers`
  * 複数の`reducer`を結合して1つにする
* `bindActionCreators`
  * `react-redux` 利用時などなにかしらの View 層で reducer にアクションを送れるようにしてくれる (dispatch(someAction())みたいにしてくれる)
* `applyMiddleware`
  * Middleware の適用
* `compose`
  * ユーティリティ, Middleware を適用した createStore を作る際などに利用

---

```javascript
const result = func1(func2(func3(arg)));

// ↓

const result = compose(func1, func2, func3)(arg);
```

---

### Action Creator

```javascript
// 一意な値をアクションごとに紐付ける (Action Type)
// Reducer側でこの値を元にどうやってstate更新するか決める
export const ADD_TODO = 'ADD_TODO';

// `type` とそのアクションごとのデータを持ったオブジェクトを返すだけの純粋な関数
export function addTodo(text) {
  return { type: ADD_TODO, text };
}
```

API 叩くのもここ

非同期処理用の Middleware 使う

- [redux-thunk](https://github.com/gaearon/redux-thunk)
- [redux-saga](https://github.com/redux-saga/redux-saga)
- [redux-observable](https://github.com/redux-observable/redux-observable)
- [redux-promise](https://github.com/acdlite/redux-promise)

---

### Reducer

アクションを受け取って現在の State をどう変更するか

受け取ったアクションの `type` によってどう変化させるか計算して、
変化させるなら必ず新しいオブジェクトの参照を返す
これによって View に変更が通知される

```javascript
// 必要なAction typeをimport
import * as types from './constants/ActionTypes';

const initialState = {};

// 初期stateは第1引数にデフォルト引数として渡す（ES6）
// 渡ってきたactionで現在のstateをどう変化させるか、またはさせないかを計算して
// させる場合は新しくオブジェクトを作成して返す
export default function someReducer(state = initialState /* 現在のstate*/, action /*dispatchされて渡ってきたアクション*/) {
  switch (action.type) {

  case types.SOME_ACTION:
    return Object.assign({}, state, 'new some state');

  case types.OTHER_ACTION:
    return Object.assign({}, state, 'new other state');

  default:
    return state;

  }
}
```

---

### Store

```javascript
import { createStore } from 'redux';
import someReducer from './someReducer';

const store = createStore(someReducer);
// storeオブジェクトは以下のメソッドをもつ
// store.getState()
  // Stateを取り出す

// store.subscribe() @returens {Function} unsubscribe
  // state変更時のlistenerを登録
  // unsubscribeする関数が返る

// store.dispatch()
  // reducerにアクションを送る
```

---

### デモ

Redux without React

Counter

[https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/redux-without-react](https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/redux-without-react)

Redux with React

Todo

[https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/redux-with-react](https://github.com/sugarshin/study-mtg/tree/master/react-flux-redux/redux-with-react)

---

参考：

[http://rebuild.fm/114/](http://rebuild.fm/114/)

---

## まとめ

参考資料

* [https://www.oreilly.co.jp/books/9784873117195/](https://www.oreilly.co.jp/books/9784873117195/)
* [http://qiita.com/advent-calendar/2014/reactjs](http://qiita.com/advent-calendar/2014/reactjs)
* [http://qiita.com/advent-calendar/2014/virtual-dom](http://qiita.com/advent-calendar/2014/virtual-dom)
* [https://speakerdeck.com/geta6/reacttofluxfalsekoto](https://speakerdeck.com/geta6/reacttofluxfalsekoto)

---

React, Flux周りを利用して書いたもの

* React, Redux実装のアプリ [https://github.com/sugarshin/figleditr](https://github.com/sugarshin/figleditr)
* React, Redux実装のアプリ [https://github.com/sugarshin/translate-annotator](https://github.com/sugarshin/translate-annotator)
* React, facebook/flux実装のアプリ [https://github.com/sugarshin/noto](https://github.com/sugarshin/noto)
* React, facebook/flux実装のアプリ [https://github.com/sugarshin/sobap](https://github.com/sugarshin/sobap)
* React, facebook/flux実装のアプリ [https://github.com/sugarshin/rmd](https://github.com/sugarshin/rmd)

* Reactコンポーネント [https://github.com/sugarshin/react-social](https://github.com/sugarshin/react-social)
* Reactコンポーネント [https://github.com/sugarshin/react-timer](https://github.com/sugarshin/react-timer)
* Reactコンポーネント [https://github.com/sugarshin/react-floatvox](https://github.com/sugarshin/react-floatvox)

* React, Reduxのスターターボイラープレート [https://github.com/sugarshin/react-redux-starter](https://github.com/sugarshin/react-redux-starter)

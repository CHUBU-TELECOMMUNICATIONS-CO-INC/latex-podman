# Podman image for LaTeX

## Usage

これでカレントディレクトリに `main.pdf` ができます．

## Author

MINETA Hiroki

## License

MIT

## Usage
```bash
git clone https://github.com/CHUBU-TELECOMMUNICATIONS-CO-INC/latex-podman.git
cd latex-podman

## Proxyが無い場合
podman build -t latex .

## 社内でProxyを利用する場合はbuild-argで環境変数を渡す
podman build --build-arg https_prorxy="${HTTPS_PROXY}" --build-arg http_proxy="${HTTP_PROXY}" -t latex .
```


## About Libraries of Special Note

* minted
  * listing系は導入や設定が煩雑だったりということもあり、モダンなライブラリとして採用しました。python3に依存するためdocker imageにから削除していません。

* siunitx
  * 何も考えずに単位を数式として表示すると斜体になってしまうなど不都合があります。これを回避するために導入しました。

* latexindent
  * latexソースコード用のformatterです。ソースコードのインデントを自動で揃えるようにしました。perlに依存するためdocker imageにから削除していません。

* svg
  * SVG形式画像を埋め込むために導入しました。

## Embedding font

一部の論文誌等ではフォントの埋め込みを提出の要件にしています。
そういった場合以下のコマンドをコンテナ内で使用することでフォントの埋め込みが可能です。

```bash
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -sOutputFile=output.pdf -f input.pdf
```

注意点として、matplotlib等でグラフをpdf形式で出力している場合は、そちらにも作成時にフォントを埋め込んでおく必要があります。
また、一部学会でグラフにtimes new romanを使用することを求めていますが、このフォントは上の方法を用いて埋め込むとフォントの規約違反となることに注意してください。Adobe Acrobat Pro DCを使用してフォントをロックする必要があります。

## PDF Version

論文等提出時に、PDFのバージョンが指定されている場合があります。
そういった場合、.latexmkrcの

```bash
$dvipdf = 'dvipdfmx %O -o %D %S';
```

を

```bash
$dvipdf = 'dvipdfmx -V 4 %O -o %D %S';
```

に変更することでバージョンを指定することができます。

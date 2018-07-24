# SiteguardLite::CustomSignature

このライブラリはSiteGuard Liteのカスタム・シグネチャファイル(`sig_custom.txt`)を扱うためのライブラリです。

このファイルはタブ区切りフォーマットですが、このライブラリではYAMLフォーマットで扱えるようにします。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'siteguard_lite-custom_signature'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install siteguard_lite-custom_signature

## Usage

```ruby
require 'siteguard_lite/custom_signature'

# Load yaml format (This gem's format)
rules = SiteguardLite::CustomSignature.load_yaml(File.read('sig_custom.yml'))

# Generate text format (SiteGuard Lite format)
SiteguardLite::CustomSignature.dump_text(rules)

# Load text format
rules = SiteguardLite::CustomSignature.load_text(File.read('sig_custom.txt'))

# Generate yaml format
SiteguardLite::CustomSignature.dump_yaml(rules)
```

## バリデーション

カスタム・シグネチャファイルには文字数やバイト数の制限を持つ項目があります。`dump_text()`メソッドではこの制限をチェックして違反している場合は例外を投げます。

## 注意

`dump_yaml()`メソッドで生成されるYAMLにはフォーマット上の制限があります。

### 配列のインデント

このgemでは以下のようなYAMLが生成されます。

```yaml
rules:
- name: exclude-foo
  comment: fooを除外する
```

以下のようにインデントされません。

```yaml
rules:
  - name: exclude-foo
    comment: fooを除外する
```

### アンカーとエイリアス

YAMLでは`&`と`*`を使ったアンカーとエイリアスを使うと重複した記述を避けることができて便利ですが、生成されるYAMLはそのようになりません。

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags and no pushing the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pepabo/siteguard_lite-custom_signature.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

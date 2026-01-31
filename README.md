# GreenDay
Green Day creates workspaces and tests for Atcoder contests
（日本語で解説した記事は[こちら](https://qiita.com/QWYNG/items/0e2e6b72bd1969d0d751))
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'green_day'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install green_day

## Usage

### Login

⚠️ **Important Notice**: AtCoder has implemented human verification (CAPTCHA) for login. Automated login may not work reliably.

If the login command fails, you can manually create a session:
1. Log in to AtCoder in your browser at https://atcoder.jp/login
2. Export your session cookie and save it as `.cookie-store` in your working directory
3. The tool will use this cookie for authenticated requests

To attempt automated login (may fail due to CAPTCHA):

    $ bundle exec green_day login

If you want to delete session, remove `.cookie-store`

This command creates directory and spec.

    $ bundle exec green_day new <contest-name>

For example

    $ bundle exec green_day new abc150

   ```
    abc150
    ├── A.rb
    ├── B.rb
    ├── C.rb
    ├── D.rb
    ├── E.rb
    ├── F.rb
    └── spec
        ├── A_spec.rb
        ├── B_spec.rb
        ├── C_spec.rb
        ├── D_spec.rb
        ├── E_spec.rb
        └── F_spec.rb
   ```

### Example of output spec

```ruby
RSpec.describe 'abc150/A.rb' do
  it 'test with "2 900\n"' do
    io = IO.popen('ruby abc150/A.rb', 'w+')
    io.puts("2 900\n")
    io.close_write
    expect(io.readlines.join).to eq("Yes\n")
  end

  it 'test with "1 501\n"' do
    io = IO.popen('ruby abc150/A.rb', 'w+')
    io.puts("1 501\n")
    io.close_write
    expect(io.readlines.join).to eq("No\n")
  end

  it 'test with "4 2000\n"' do
    io = IO.popen('ruby abc150/A.rb', 'w+')
    io.puts("4 2000\n")
    io.close_write
    expect(io.readlines.join).to eq("Yes\n")
  end

end
```

### Manual Cookie Setup (Workaround for Login Issues)

If automated login fails due to CAPTCHA verification, you can manually set up authentication:

1. **Log in to AtCoder** in your web browser at https://atcoder.jp/login
2. **Export your session cookie** using one of these methods:
   - Browser Developer Tools: Open DevTools → Application/Storage → Cookies → Copy `REVEL_SESSION` cookie
   - Browser Extension: Use a cookie export extension to save cookies in HTTP::Cookie YAML format
3. **Create `.cookie-store` file** in your project directory with this format:
   ```yaml
   ---
   - !ruby/object:HTTP::Cookie
     name: REVEL_SESSION
     value: YOUR_SESSION_VALUE_HERE
     domain: atcoder.jp
     for_domain: false
     path: "/"
     secure: false
     httponly: true
     expires:
     max_age: 604800
     created_at: 2026-01-31 00:00:00.000000000 Z
     accessed_at: 2026-01-31 00:00:00.000000000 Z
   ```
4. **Update timestamps** to current date and adjust `max_age` (in seconds) as needed

After setting up the cookie file, you can use `green_day new` command without needing to login again.

### Template
You can use a template file for creating specs.
GreenDay uses `template.rb` in the working directory as a template file.

```ruby
requires "math"
x = gets.to_i
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/QWYNG/green_day. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GreenDay project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/QWYNG/green_day/blob/master/CODE_OF_CONDUCT.md).

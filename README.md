# Localized

A simple gem for Rails 3 that helps set the locale for your application from a
subdomain. It also contains a way for overriding the "site" in url helpers.

## Setup

1. Add a config/localized.yml file with your supported subdomain/site name and locale mappings.

2. Add your domains to your /etc/hosts file for development:

         127.0.0.1 www.mysite.localhost # default locale
         127.0.0.1 www.it.mysite.localhost
         127.0.0.1 www.ca.mysite.localhost

3. Create your "change locale widget" using simple url helpers:

         root_url(:site => :us) # => http://www.mysite.com/
         root_url(:site => :it) # => http://www.it.mysite.com/
         root_url(:site => :ca) # => http://www.ca.mysite.com/

  OR to keep the current locale:

    root_url # => http://www.<whatever the current site is>.mysite.com

## Other Features

In addition to the runtime features, there is a feature for
converting all of the locale files into a csv so it can be
updated to Google docs (or Excel) and translations can be made
easier than if a user was using YAML.

        Localized::Convert.to_csv('/a/file.csv')

## TODO

1. #from_csv

2. Support for google docs so translations can be synchronized


## Contributing

This is a very simple gem and I am sure you could think of something you could
add to it, please create a pull request.

## Author

Paul Hepworth (http://peppyheppy.com)

## License

The MIT License (MIT)
Copyright (c) 2011 Paul Hepworth

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


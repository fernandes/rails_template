# Rails Template

Kickstart a new rails app, as easy as

```bash
rails new foo -m /path/to/template.rb
```

## rails.rc

To automate the use of this template, I have a `rails.rc` with the following content.

```bash
⌁ cat ~/.railsrc 
--database=postgresql
--skip-javascript
--skip-hotwire
--skip-asset-pipeline
-m /path/to/rails_template/template.rb
```

## Applying Individual Tools

This template was created keeping in mind we can apply it to a new app, or just individual tools
to existing rails apps, just apply individual, just run

```bash
bin/rails app:template LOCATION=/path/to/rails_template/tools/<tool>.rb
```

## References

This template is not intended to general use, I'm glad if you use and works for you, but the main goal is not support every single case. I'm opening the source so we can share from each other, think about this template as a _dotfiles_ repo.

You can check all the references (that I learned a lot from it), and create your very unique template

- [Rails Guides](https://guides.rubyonrails.org/generators.html) is an amazing resource to learn the basic of the generators
- [Rails Bytes](https://railsbytes.com/) has a lot of templates to explore and apply
- [mattbrictson's template](https://github.com/mattbrictson/rails-template) is a great template to use and learn a lot from it


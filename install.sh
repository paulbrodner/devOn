rm pkg/devOn-0.0.1.gem
gem uninstall devOn
rake build
gem install pkg/devOn-0.0.1.gem

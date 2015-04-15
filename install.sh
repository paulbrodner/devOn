rm pkg/devOn-1.0.0.gem
gem uninstall devOn
rake build
gem install pkg/devOn-1.0.0.gem

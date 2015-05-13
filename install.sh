#!/usr/bin/env bash
[ -f pkg/devOn-1.0.1.gem ] && rm pkg/devOn-1.0.1.gem
gem uninstall devOn
rake build
gem install pkg/devOn-1.0.1.gem

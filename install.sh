#!/usr/bin/env bash
VERSION=2.0.0
[ -f pkg/devOn-${VERSION}.gem ] && rm pkg/devOn-${VERSION}.gem
gem uninstall devOn
rake build
gem install pkg/devOn-${VERSION}.gem --no-ri --no-rdoc

# DogStatsd::Instrumentation

[![Gem Version](https://badge.fury.io/rb/dogstatsd-instrumentation.svg)](http://badge.fury.io/rb/dogstatsd-instrumentation)
[![CircleCI](https://circleci.com/gh/wealthsimple/dogstatsd-instrumentation.svg?style=shield)](https://circleci.com/gh/wealthsimple/dogstatsd-instrumentation) 
[![Dependency Status](https://gemnasium.com/badges/github.com/wealthsimple/dogstatsd-instrumentation.svg)](https://gemnasium.com/github.com/wealthsimple/dogstatsd-instrumentation)
[![Code Climate](https://codeclimate.com/github/wealthsimple/dogstatsd-instrumentation/badges/gpa.svg)](https://codeclimate.com/github/wealthsimple/dogstatsd-instrumentation)
[![codecov](https://codecov.io/gh/wealthsimple/dogstatsd-instrumentation/branch/master/graph/badge.svg)](https://codecov.io/gh/wealthsimple/dogstatsd-instrumentation)
[![Gitter chat](https://img.shields.io/gitter/room/wealthsimple/Lobby.svg?style=flat)](https://gitter.im/wealthsimple/Lobby)


<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
  - [Examples](#examples)
- [Requirements](#requirements)
- [Setup](#setup)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features

DogStatsd::Instrumentation collects various [ActiveSupport::Notifications](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html) and sends them to StatsD, more precisely, Datadog's DogStatsD.


## Examples

# Requirements

0. [Ruby 2.3.0](https://www.ruby-lang.org)

# Setup

For a secure install, type the following (recommended):

    gem cert --add <(curl --location --silent /gem-public.pem)
    gem install dogstatsd-instrumentation --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification
while allowing the installation of unsigned dependencies since they are beyond the scope of this
gem.

For an insecure install, type the following (not recommended):

    gem install dogstatsd-instrumentation

Add the following to your Gemfile:

    gem "dogstatsd-instrumentation"

# Tests

To test, run:

    bundle exec rake

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Major (X.y.z) - Incremented for any backwards incompatible public API changes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

[MIT License](LICENSE.md)

Copyright (c) 2016 [Wealthsimple](https://wealthsimple.com).

# History

Read [CHANGES](CHANGES.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

# Credits

Developed by [Marco Costa](http://marcotc.com) at [Wealthsimple](https://wealthsimple.com).

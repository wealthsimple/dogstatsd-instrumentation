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

AwsCron does all the housekeeping related to handling requests from [AWS Elastic Beanstalk Periodic Tasks](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features-managing-env-tiers.html#worker-periodictasks).
* Handles HTTP responses, even in case of exceptions
* Reliable error logging, using your preferred logger
* Timezone-aware cron scheduling
  * AWS only allows UTC scheduling. AwsCron helps you use your desired timezone instead. 

Keep in mind that you still have to set up an AWS Elastic Beanstalk environment with a proper `cron.yml` file.

## Examples

### Rails

```ruby
class MyAwsControllerResponsibleForCronCalls
  include AwsCron::Controller
  
  timezone 'America/New_York'
   
  def foo_endpoint
    run { GenericTask.run } # No timezone checks made, just response handling and logging
  end
  
  def timezoned_9am_endpoint
    run_in_tz '0 9 * * *' do
      TimezoneSpecific9AMTask.run
    end
  end
end
```

### Complex example

```ruby
class MyAwsControllerResponsibleForCronCalls
  include AwsCron::Controller
   
  def foo_endpoint
    run { GenericTask.run }
  end
  
  def timezoned_9am_endpoint
    run_in_tz '0 9 * * *' do
      TimezoneSpecific9AMTask.run
    end
  end
  
  protected

  def time_provider # Prefer using `timezone 'ZONE'`, unless you want a custom time provider
    ActiveSupport::TimeZone.new('America/New_York')
  end
  
  def return_object # AWS Scheduler always expects ok, even in case of errors
    render :json => {message: 'ok'}
  end
end
```

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

# WayOfWorking::Audit::Github

<!-- Way of Working: Main Badge Holder Start -->
![Way of Working Badge](https://img.shields.io/badge/Way_of_Working-v2.0.1-%238169e3?labelColor=black)
<!-- Way of Working: Additional Badge Holder Start -->
<!-- Way of Working: Badge Holder End -->

[![Gem Version](https://badge.fury.io/rb/way_of_working-audit-github.svg)](https://badge.fury.io/rb/way_of_working-audit-github)

A [Way of Working](https://github.com/HealthDataInsight/way_of_working) plugin that provides a registry and auditing tool for GitHub repositories. Rules can check for both missing/incorrect files and mis-configuration of the repository itself. Many existing plugins have defined their own rules to check that they have been adopted properly.

Work is ongoing on a plugin for CIS GitHub Benchmark compliance testing.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add way_of_working-audit-github
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install way_of_working-audit-github
```

## Usage

Define the following environment variables:

- `GITHUB_ORGANISATION`: the name of your organisation being scanned (as used in the GitHub URL)
- `GITHUB_TOKEN`: a PAT token with sufficient permission to access repositories and their configuration.

Then to run the GitHub audit for your project, use:

```bash
way_of_working exec audit_github
```

By default, the audit runs only against repositories that are configured as git remotes in your current project. To audit all repositories in your organisation, use the `--all-repos` flag:

```bash
way_of_working exec audit_github --all-repos
```

You can filter repositories by topic using the `--topic` flag. This accepts a single topic and will only audit repositories that have that topic:

```bash
# Audit all repos with the 'way-of-working' topic
way_of_working exec audit_github --all-repos --topic way-of-working

# Audit all repos with the 'indoor-mapping' topic
way_of_working exec audit_github --all-repos --topic indoor-mapping
```

To automatically fix issues where possible, use the `--fix` flag:

```bash
# Audit and fix issues in the current project
way_of_working exec audit_github --fix

# Audit and fix issues in all repos with a specific topic
way_of_working exec audit_github --all-repos --topic way-of-working --fix
```

Note: The `--fix` flag is passed to individual rules, which may implement automatic fixes for their specific checks. Not all rules support automatic fixing.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/HealthDataInsight/way_of_working-audit-github>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/HealthDataInsight/way_of_working-audit-github/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the way_of_working-audit-github project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/HealthDataInsight/way_of_working-audit-github/blob/main/CODE_OF_CONDUCT.md).

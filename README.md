# ey_cli

[![Build Status](https://secure.travis-ci.org/calavera/ey_cli.png)](http://travis-ci.org/calavera/ey_cli)

An alternative command line interface for Engine Yard Cloud.

Still in early development.

## Installation

```
gem install ey_cli
```

## Usage

```
ey_cli command [args]
```

More information available about the available commands if you run:

```
ey_cli help
```

## Examples

- How to create a new application:

```
ey_cli create_app
```

  That's all that you need if you're under the application directory and this already is in a git repository. It also runs a first deploy for free.

- How to perform a new deploy:

```
ey_cli deploy
```

  That's all, if the CLI doesn't know what you want to deploy it politely asks you.

## Avaliable commands
```
  General info
    accounts                     List the accounts associated to a user.
    console                      Start an interactive session to use ey_cli.
    help                         Show commands information.

  Applications
    apps                         List the applications associated to a user.
    create_app                   Create a new application. It takes the information from the current directory.
    show                         Show information and status of an application.

  Environments
    create_env                   Create a new environment for an application.
    deploy                       Run a deploy for an application.
```
## Motivation

engineyard gem is strongly coupled to Thor, and I don't like the
conventions that you have to assume because of this coupling.

engineyarg gem connects to your boxes directly to perform tasks. I
prefer to connect to the available APIs and have a unique entry point.

**Is this a replacement for engineyard gem, then?** No, for now it's just an
experiment and only implements a few number of commands.

## Development notes

Check the opened issues if you want to help and don't know where to
start from.

Run this command to execute the tests:

```
bundle rake
```

Any pull request and contribution is really appreciated.

## Notes about the structure:

How this library is structured:

### Commands

What the user executes. Each one can provide its own command line parser
to accept further options but one is provided by default.

### Controllers

Code and stuff. Show messages, decide what to do...

### Models

Connect to the api. Abstraction over the json responses.

# Copyright

Copyright (c) 2011 David Calavera. See LICENSE for details.

# Gatherlogs InSpec Profile

This is a proof of concept to see if using InSpec to do some initial
validation on gatherlog output from chef-products is viable.

Get InSpec from: http://inspec.io

## Requirements

1. inspec (currently tested with v2 but should work with v1)
2. ruby 2.4+
3. bundler

## Installation

1. Download code and the gems

  ```bash
  git clone https://github.com/teknofire/gatherlogs-inspec-profiles
  cd gatherlogs-inspec-profiles
  bundle
  ```

2. Add `gatherlogs-inspec-profiles/bin` to your path, put this in your `.bashrc` or the equivalent file for your shell.

  ```
  export PATH=$PATH:PATH/TO/gatherlogs-inspec-profiles/bin;
  ```

## Usage

You will need to be in the directory with the expanded gather-logs tar file to run this tool and should be in the same directory where you find the `installed-packages.txt` or `platform_version.txt` files.

Currently available profiles
  * `chef-server`
  * `automate`

Run `check_log` like this to validate the gather-log files in the current directory.

```
# to check gather-logs from chef-server use
check_log chef-server
# to check gather-logs from automate use
check_log automate
# etc.....
```

Available options

```
Usage: check_logs [OPTIONS] PROFILENAME
Options:
 Options:
     -a        Show all controls (only failed controls are shown by default)
     -v        Show verbose control results
     -h        Print this message
```

## Example output

```
$ check_log chef-server -f -q

InSpec profile for Chef-Server generated gather-logs
  × gatherlogs.chef-server.package: check that chef-server is installed
    ⓘ The installed version of Chef-Server is old and should be upgraded

  × gatherlogs.chef-server.postgreql-upgrade-applied: make sure customer is using chef-server version that includes postgresl 9.6
    ⓘ Chef Server < 12.16.2 uses PostgreSQL 9.2 and will perform a major upgrade
      to 9.6.  Please make sure there is enough disk space available to perform
      the upgrade as it will duplicate the database on disk.

  × chef-server.gatherlogs.reporting-with-2018-partition-tables: make sure installed reporting version has 2018 parititon tables fix
    ⓘ Reporting < 1.7.10 has a bug where it does not create the 2018
      partition tables. In order to fix this the user should install >= 1.8.0
      and follow the instructions in this KB:
      https://getchef.zendesk.com/hc/en-us/articles/360001425252-Fixing-missing-2018-Reporting-partition-tables
```

## TODO

* [ ] It would be nice if we could test to see if `noexec` is set on `/tmp`
* [x] Figure out how to write a custom reporter for InSpec (hacked around using json output and formater script)

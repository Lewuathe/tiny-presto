# tiny-presto [![Run unit tests](https://github.com/Lewuathe/tiny-presto/actions/workflows/ruby.yml/badge.svg)](https://github.com/Lewuathe/tiny-presto/actions/workflows/ruby.yml) ![Gem](https://img.shields.io/gem/v/tiny-presto) ![Gem](https://img.shields.io/gem/dt/tiny-presto)

Tiny [Trino](https://trino.io/) cluster to check the compatibility of query result by using the specific Trino version.

**NOTE: The brand name of [Presto was migrated to Trino](https://trino.io/blog/2020/12/27/announcing-trino.html). Although the internal docker image used in tiny-presto was also migrated to [Trino](https://hub.docker.com/r/trinodb/trino), we keep the package name `tiny-presto` to avoid the installation trouble.**

# Install

```
$ gem install tiny-presto
```

# Prerequisites

tiny-presto uses Docker to run single node Presto cluster. Please ensure to install the Docker engine properly in advance.

See [Docker Engine overview](https://docs.docker.com/install/)

# Usage

You can run the query easily as follows.

```ruby
rows = TinyPresto.run('show schemas')
# => [["default"], ["information_schema"]]
```

As tiny-presto uses the memory connector as default, it is also possible to create a table.

```ruby
TinyPresto.run("create table ctas1 as select * from (values (1, 'a'), (2, 'b')) t(c1, c2)")
rows = TinyPresto.run("select * from ctas1")
# => [[1, 'a'], [2, 'b']]
```

To check the result consistency, `verify` method is available.

```ruby
result = TinyPresto.verify('show schemas', [["default"], ["information_schema"]])
# result is true if the returned value by the query matched with the given expected result.
```

To ensure to delete the tiny-presto cluster, make sure to call `ensure_stop` before exiting.

```ruby
TinyPresto.ensure_stop
```

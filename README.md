# tiny-presto [![Actions Status](https://github.com/Lewuathe/tiny-presto/workflows/test/badge.svg)](https://github.com/Lewuathe/tiny-presto/actions) ![Gem](https://img.shields.io/gem/v/tiny-presto) ![Gem](https://img.shields.io/gem/dt/tiny-presto)

Tiny [Presto](https://prestosql.io/) cluster to check the compatibility of query result by using the specific Presto version.

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
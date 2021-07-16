# Changelog

## 0.2.2

* Fix unknow association from ecto causes error.

## 0.2.1

* Support belongs to association where the child entity does not reference to parent entity through primary key.

## 0.2.0

* Support self-referencing schema. Fix bug where self-referencing schema causes fictitious to end up in infinite loop.
* Enable fictitious value to be override with null value by providing `:null` as the value.
* Remove `ecto_sql` and `postgrex` as dependencies.

## 0.1.1

* First release of fictitious

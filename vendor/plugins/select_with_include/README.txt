README for select_with_include
==============================

This gem is provides a patch for ActiveRecord to enable the use of the :select
option used in combination with the :include option.

In the current version ActiveRecord just ignores any :select option if the
:include option is specified.

== Usage:

The support of the :select provided from this gem is limited.

The syntax supported for the select is only a string in the form

"table1.column1, table1.column2, table2.column4"

syntax like 

"table1.*, table2.column1, table2.column4"

is also allowed

At the moment functions or custom calculated field are not supported.

== Installation

  gem install select_with_include

== Author

Author of this gem is Paolo Negri

== License

this gem is distributed under the MIT license

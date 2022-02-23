Components
==========

Issues
------

Lots of duplication in Button.button:

  * skip list in assigns_to_attributes
  * assigning defaults
  * rendering content within the button or a

.format_datetime is duplicated on components_live and timestamps_live - MOVED TO Page module... for now along with .h1, .h2 and .components_container. Not sure where all this should end up?

Table

  * Background classes applied, leave to the parent to define?

Paginator

  * Some wrapper classes applied (white background). This should be left to the parent to define?

Opportunities for improvement
-----------------------------

ResourceDataTable:

* Toolbar/buttons?
* Implement filter reset on resource loader? (assigns default filter map to filter map)

Sizes
-----

Need to keep an eye on values used for sizes, to keep them consistent. Following components have sizes

  * Buttons
  * Nothing else yet, but there may be one day

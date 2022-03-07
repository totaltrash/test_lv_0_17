Components
==========

Issues
------

Remove all references to MyAppWeb. Everything in here is supposed to be reuseable:

  * Push app specific stuff out to wrappers (pages displayed in Page.wrapper nav bar)
  * What to do with Session? defined in MyAppWeb, but passed into resource loaded as an option, or by config????

Add new top nav item called 'Learning' and move temp assigns, timestamps and uploads under that.

Move Message section from components_live into own live view under 'Learning'

Lots of duplication in Button.button:

  * skip list in assigns_to_attributes
  * assigning defaults
  * rendering content within the button or a

.format_datetime is duplicated on components_live and timestamps_live - MOVED TO Page module... for now along with .h1, .h2 and .components_container. Not sure where all this should end up?

Table

  * Background classes applied, leave to the parent to define?

Paginator

  * Does not work with a range of 0 (ie don't show other pages, just the chevrons and dots). possibly just want a `minimal` prop
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

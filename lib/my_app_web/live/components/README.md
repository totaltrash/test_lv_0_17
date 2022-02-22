Components
==========

WIP - todo
----------

Finish handling all assigns passed to clearable_text_input, as per Surface version

Finish ResourceDataTable, add active checkbox, events handlers etc

Check event handlers (change page etc) don't leak/collide. We have to be able to handle multiple data tables embedded in one live view

ResourceDataTable:

* Finish filter:
  - implement filter reset (assigns default filter map to filter map)
* Implement session
* Toolbar/buttons?
* Document all assigns, including slots. Ensure all are working as expected
* Look for disabled assigns and remove/implement
* Rename
* Optional labels

Issues
------

Lots of duplication in Button.button:

  * skip list in assigns_to_attributes
  * assigning defaults
  * rendering content within the button or a

Session keys: atoms or strings? Atoms at mo, but what's the point? Lots of converting strings to atoms just to store a session value?

.format_datetime is duplicated on components_live and timestamps_live - MOVED TO Page module... for now along with .h1, .h2 and .components_container. Not sure where all this should end up?

Table

  * Background classes applied, leave to the parent to define?

Paginator

  * Some wrapper classes applied (top border, white background). This should be left to the parent to define?
  * change_page_target is necessary for when the paginator is used by components... but should the change_page assign be able to accept a tuple `{@myself, "change_page"}` as well as just an event name for when used by live views?

Sizes
-----

Need to keep an eye on values used for sizes, to keep them consistent. Following components have sizes

  * Buttons
  * Nothing else yet, but there may be one day

# project_dom_tree
Like leaves on the wind

[A data structures, algorithms, file I/O, ruby and regular expression (regex) project from the Viking Code School](http://www.vikingcodeschool.com)

Started - Josh and Jeff on 1/14
Finished - Josh on 1/15

Thought Question:

Is your solution for parsing the DOM into nodes more of a "breadth first" or "depth first" approach?

It is "depth first" - it goes deeper into the tree with each start tag and comes back up a level for every end tag. This way, it can simply read down the file and preserve the order of the html document.

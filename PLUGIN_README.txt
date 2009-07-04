README - ANGELTEMPLATE PLUGIN SDK

You can create your own field types for AngelTemplate. SamplePluginFieldType is a simple example field type, with source code and lots of comments.

Essentially, a plugin field is simply a loadable bundle with a Cocoa class (or several) in it that adhere(s) to the UKTemplateFieldPluginProtocol as declared in UKTemplateFieldProtocol.h. Note that this header is a tad on the complicated side. Reading the sample plugin's source code first will probably make things easier to understand.

Each template field class you provide in there can register for one or more types (e.g. you can have the same class handle signed and unsigned variants of a type).
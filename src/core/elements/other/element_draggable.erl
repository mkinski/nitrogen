% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_draggable).
-include ("wf.inc").
-compile(export_all).

reflect() -> record_info(fields, draggable).

render_element(HtmlID, Record, Context) -> 
	% Get properties...
	PickledTag = wff:pickle(Record#draggable.tag),
	
	GroupClasses = groups_to_classes(Record#draggable.group),

	Handle = case Record#draggable.handle of
		undefined -> "null";
		Other2 -> wf:f("'.~s'", [Other2])
	end,

	Helper = case Record#draggable.clone of
		true -> clone;
		false -> original
	end,
	
	Revert = case Record#draggable.revert of
		true -> "true";
		false -> "false";
		valid -> "'valid'";
		invalid -> "'invalid'"
	end,

	% Write out the script to make this element draggable...
	Script = #script {
		script=wf:f("Nitrogen.$draggable(obj('me'), { handle: ~s, helper: '~s', revert: ~s }, '~s');", [Handle, Helper, Revert, PickledTag])
	},
	{ok, Context1} = wff:wire(Record#draggable.id, Script, Context),

	% Render as a panel...
	element_panel:render_element(HtmlID, #panel {
		class="draggable " ++ GroupClasses ++ " " ++ wf:to_list(Record#draggable.class),
		style=Record#draggable.style,
		body=Record#draggable.body
	}, Context1).
	
groups_to_classes([]) -> "";
groups_to_classes(undefined) -> "";
groups_to_classes(Groups) ->
	Groups1 = lists:flatten([Groups]),
	Groups2 = ["drag_group_" ++ wf:to_list(X) || X <- Groups1],
	string:join(Groups2, " ").
	
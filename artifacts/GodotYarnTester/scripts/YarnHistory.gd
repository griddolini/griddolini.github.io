extends RichTextLabel

func _ready():
	# Highlight commands
	#add_color_region("!*", "", Color.red, false)
	# Highlight commands
	#add_color_region("$*", "", Color.yellowgreen, false)
	# Highlight commands
	#add_color_region("<<", ">>", Color.magenta, false)
	# Highlight node traversal options
	#add_color_region("|", "]]", Color.skyblue, false)
	# Highlight speaker
	#add_color_region("\"", "\"", Color.darkorange, false)
	
	Storyteller.connect("dialogue_spoken", self, "write_line")
	Storyteller.connect("choices_presented", self, "write_choice")
	Storyteller.connect("custom_command_fired", self, "write_logic")
	Storyteller.connect("dialogue_ended", self, "end_convo")
	Storyteller.connect("parse_error", self, "show_error")
	
	Storyteller.connect("if_statement_pass", self, "if_statement_pass")
	Storyteller.connect("if_statement_fail", self, "if_statement_fail")
	
	Storykeeper.connect("variable_added", self, "show_var_activity")
	Storykeeper.connect("variable_updated", self, "show_var_activity")

func _on_ClearHistory_pressed():
	bbcode_text = ""

func write_line(speaker, text):
	if speaker != "":
		self.bbcode_text += "[color=#cc99ff]" + speaker + "[/color]: " + text + "\n";
	else:
		self.bbcode_text += text + "\n";

func show_error(text):
	self.bbcode_text += "[color=#FF0000]" + text + "[/color]\n";
	
func write_choice(options_stack):
	for option in options_stack:
		self.bbcode_text += "[[ " + option["text"] + " |[color=#aaccFF]" + option["marker"] + " ]][/color]\n";
	
func write_logic(command, arguments):
	if !arguments.empty():
		self.bbcode_text += "[color=#FF00FF]<< " + command + " : " + str(arguments) + " >>[/color]\n";
	else:
		self.bbcode_text += "[color=#FF00FF]<< " + command + " >>[/color]\n";

func show_var_activity(variable, value):
	self.bbcode_text += "[color=#00FF00]" + variable + "[/color] was set to [color=#00FF00]" + str(value) + "[/color]\n";

func if_statement_pass(subject_name, subject_value, operation, value):
	self.bbcode_text += "[color=#009999]IF PASSED[/color]: Tested for [color=#00FF00]" + subject_name 
	self.bbcode_text += "[/color] : [color=#00FF00]" + str(subject_value) + "[/color] [color=#ff0066]" + str(operation) + "[/color] " +str(value) + "\n"

func if_statement_fail(subject_name, subject_value, operation, value):
	self.bbcode_text += "[color=#ff9900]IF FAILED[/color]: Tested for [color=#00FF00]" + subject_name 
	self.bbcode_text += "[/color] : [color=#00FF00]" + str(subject_value) + "[/color] [color=#ff0066]" + str(operation) + "[/color] " + str(value) + "\n"

func end_convo():
	if !self.bbcode_text.empty():
		self.bbcode_text += "[color=#FFFF00]Conversation End[/color]\n";

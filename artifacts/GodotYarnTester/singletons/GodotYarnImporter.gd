extends Node
#
# A YARN Importer for Godot
#
# Credits: 
# Original - Dave Kerr (http://www.naturallyintelligent.com)
# Modifications - Grid Sherman

# Latest: https://github.com/naturally-intelligent/godot-yarn-importer
# 
# Yarn: https://github.com/InfiniteAmmoInc/Yarn
# Twine: http://twinery.org
# 
# Yarn: a ball of threads (Yarn file)
# Thread: a series of fibres (Yarn node)
# Fibre: a text or choice or logic (Yarn line)

var yarn = {}
var current_yarn_file = ""

# OVERRIDE METHODS
#
# called to request new dialog
# warning-ignore:unused_argument
func say(speaker, text):
	pass
	
# called to request new choice button
# warning-ignore:unused_argument
func choice(text, marker):
	pass

# called to request internal logic handling
# warning-ignore:unused_argument
func logic(instruction):
	pass
	
# called for each line of text
func yarn_text_variables(text):
	return text
	
# called when "settings" node parsed
# warning-ignore:unused_argument
func story_setting(setting, value):
	pass
	
# called for each node name
# warning-ignore:unused_argument
func yarn_custom_logic(to):
	pass

# called for each node name (after)
# warning-ignore:unused_argument
func yarn_custom_logic_after(to):
	pass

# START SPINNING YOUR YARN
#
func spin_yarn(file, start_thread = false):
	yarn = load_yarn(file)
	# Find the starting thread...
	if not start_thread:
		start_thread = yarn['start']
	current_yarn_file = file
	# First thread unravel...
	yarn_unravel(start_thread)

# Internally create a new thread (during loading)
func new_yarn_thread():
	var thread = {}
	thread['title'] = ''
	thread['kind'] = 'branch' # 'branch' for standard dialog, 'code' for gdscript
	thread['tags'] = [] # unused
	thread['fibres'] = []
	return thread

# Internally create a new fibre (during loading)
func new_yarn_fibre(line):
	# choice fibre
	if line.substr(0,2) == '[[':
		var fibre = {}
		fibre['kind'] = 'choice'
		line = line.replace('[[', '')
		line = line.replace(']]', '')
		if line.find('|') != -1:
			var split = line.split('|')
			fibre['text'] = split[0]
			fibre['marker'] = split[1]
		else:
			fibre['text'] = "NaN"
			fibre['marker'] = line
		return fibre
	# logic instruction (not part of official Yarn standard)
	elif line.substr(0,2) == '<<':
			var fibre = {}
			fibre['kind'] = 'logic'
			line = line.replace('<<', '')
			line = line.replace('>>', '')
			fibre['instruction'] = line
			return fibre
	# text fibre
	var fibre = {}
	fibre['kind'] = 'text'
	if line.find(':') != -1:
		var split = line.split(':')
		fibre['speaker'] = split[0]
		fibre['text'] = split[1]
	else:
		fibre['speaker'] = ""
		fibre['text'] = line
	return fibre

# Create Yarn data structure from file (must be *.yarn.txt Yarn format)
func load_yarn(path):
	var yarn = {}
	yarn['threads'] = {}
	yarn['start'] = false
	yarn['file'] = path
	var file = File.new()
	file.open(path, file.READ)
	if file.is_open():
		# yarn reading flags
		var start = false
		var header = true
		var thread = new_yarn_thread()
		# loop
		while !file.eof_reached():
			# read a line
			var line = file.get_line()
			# header read mode
			if header:
				if line == '---':
					header = false
				else:
					var split = line.split(': ')
					if split[0] == 'title':
						var title_split = split[1].split(':')
						var thread_title = ''
						var thread_kind = 'branch'
						if len(title_split) == 1:
							thread_title = split[1]
						else:
							thread_title = title_split[1]
							thread_kind = title_split[0]
						thread['title'] = thread_title
						thread['kind'] = thread_kind
						if not yarn['start']:
							yarn['start'] = thread_title
			# end of thread
			elif line == '===':
				header = true
				yarn['threads'][thread['title']] = thread
				thread = new_yarn_thread()
			# fibre read mode
			else:
				line = line.strip_edges()
				var fibre = new_yarn_fibre(line)
				if fibre:
					thread['fibres'].append(fibre)
	else:
		print('ERROR: Yarn file missing: ', filename)
	return yarn

# Main logic for node handling
func yarn_unravel(to, from=false):
	yarn_custom_logic(to)
	if to in yarn['threads']:
		var thread = yarn['threads'][to]
		match thread['kind']:
			'branch':
				for fibre in thread['fibres']:
					match fibre['kind']:
						'text':
							var text = yarn_text_variables(fibre['text'])
							say(fibre['speaker'],text)
						'choice':
							var text = yarn_text_variables(fibre['text'])
							choice(text, fibre['marker'])
						'logic':
							var instruction = fibre['instruction']
							logic(instruction)
	else:
		print('WARNING: Missing Yarn thread: ', to, ' in file ',yarn['file'])
	yarn_custom_logic_after(to)

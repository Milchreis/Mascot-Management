
var FILE = "res://data/events.csv"
var events = []

func get_random_event():
	if events.size() == 0: _load()
	return events[randi() % events.size()]

func _load():
	var f = File.new()
	if not f.file_exists(FILE):
		print("File not found: %s" % FILE)
		return
	f.open(FILE, File.READ)
	
	var currentLine = 0
	while not f.eof_reached():
		currentLine += 1
		var line = f.get_line()
		var parts = line.split(";", false)
		
		if currentLine == 1 || parts.size() == 0: continue
		
		events.append(Event.new(parts))

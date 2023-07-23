class_name RandomEvents
extends Node

const FILE = "res://data/events.csv"
const EVENTS = []

static func get_random_event():
	if EVENTS.size() == 0: _load()
	return RandomUtil.getRandom(EVENTS)

static func _load():
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
		
		EVENTS.append(Event.new(currentLine, parts))

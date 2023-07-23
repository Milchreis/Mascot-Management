class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "user://savegame.tres"

export(int) var balance = 500
export(int) var passedDays = 0
export(float) var dayDurationInSeconds = 10.0

export(Array) var employees = []
export(Array) var openEvents = []
export(Array) var applicants:Array = []

func write_savegame(model) -> void:
	balance = model.balance
	passedDays = model.passedDays
	dayDurationInSeconds = model.dayDurationInSeconds
	employees = model.employees
	openEvents = model.openEvents
	applicants = model.applicants
	ResourceSaver.save(SAVE_GAME_PATH, self)
	
static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null

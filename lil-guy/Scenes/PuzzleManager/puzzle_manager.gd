extends Node3D

var dict_puzzle_button: Dictionary
var dict_puzzle_door: Dictionary
var solve_conditions: Dictionary
var puzzle_solved: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals._register_puzzle_piece.connect(_register_pieces)
	GlobalSignals._update_puzzle_piece.connect(_update_piece)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _register_pieces(piece, parent):
	if self == parent:
		for group in piece.get_groups():
			match group:
				"Button":
					dict_puzzle_button[piece] = {"pressed": piece.pressed}
					solve_conditions[piece] = {"solved": piece.pressed}
					print("Registered Puzzle Piece: " + str(piece))
				"PuzzleDoor":
					dict_puzzle_door[piece] = {"open": piece.open}
					print("Registered Door: " + str(piece))
				null:
					print("this is not a puzzle piece")

func _update_piece(piece, variable):
	for group in piece.get_groups():
			match group:
				"Button":
					solve_conditions[piece]["solved"] = variable
					#print(solve_conditions)
				"PuzzleDoor":
					pass
				null:
					print("update piece called by non-puzzle piece. Check group. " + str(piece))
	
	var unsolved_remaining: int = 0
	for cond in solve_conditions:
		if cond["pressed"] == false:
			unsolved_remaining += 1
	
	if puzzle_solved == false:
		if unsolved_remaining > 0:
			pass
			#print("not solved")
		elif unsolved_remaining == 0:
			puzzle_solved = true
			GlobalSignals._puzzle_completed.emit(puzzle_solved)
			print("solved")

extends Resource

export (int, -1, 99) var chapter = -1 setget set_chapter, get_chapter
export (int, -1, 99) var level = 0 setget set_level, get_level
export (int, 0, 99) var checkpoint = 0 setget set_checkpoint, get_checkpoint
export (int, 0, 999) var dialogue = 0

#### ACCESSORS ####

func set_chapter(value: int): chapter = value
func get_chapter() -> int: return chapter
func add_to_chapter(value: int): set_chapter(get_chapter() + value)

func set_level(value: int): level = value
func get_level() -> int: return level
func add_to_level(value: int): set_level(get_level() + value)

func set_checkpoint(value: int): checkpoint = value
func get_checkpoint() -> int: return checkpoint
func add_to_checkpoint(value: int): set_checkpoint(get_checkpoint() + value)

extends Resource

export (int, -1, 99) var chapter = -1 setget set_chapter, get_chapter
export (int, -1, 99) var level = 0 setget set_level, get_level
export (int, 0, 99) var checkpoint = 0 setget set_checkpoint, get_checkpoint
export (int, 0, 999) var dialogue = 0
export (int, 0, 999999999) var main_xion = 0 setget set_main_xion, get_main_xion
export (int, 0, 9999) var main_materials = 0 setget set_main_materials, get_main_materials
#int size 9 223 [372 036 854 <775 807>] - score_xion and score_gears indication

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

func set_main_xion(value: int): main_xion = value
func get_main_xion() -> int: return main_xion
func add_to_main_xion(value: int): set_main_xion(get_main_xion() + value)

func set_main_materials(value: int): main_materials = value
func get_main_materials() -> int: return main_materials
func add_to_main_materials(value: int): set_main_materials(get_main_materials() + value)

// This file is part of GNOME Games. License: GPLv3

public class Games.GenericGame : Object, Game {
	private string _name;
	public string name {
		get {
			_name = title.get_title ();

			return _name;
		}
	}

	public Icon? icon {
		get { return null; }
	}

	private Title title;
	private Runner runner;

	public GenericGame (Title title, Runner runner) {
		this.title = title;
		this.runner = runner;
	}

	public Runner get_runner () throws Error {
		return runner;
	}
}

// This file is part of GNOME Games. License: GPLv3

private class Games.PcEngineGame : Object, Game {
	private const string FINGERPRINT_PREFIX = "pc-engine";
	private const string MODULE_BASENAME = "libretro-pc-engine.so";
	private const bool SUPPORTS_SNAPSHOTTING = true;

	private FingerprintUID _uid;
	public FingerprintUID uid {
		get {
			if (_uid != null)
				return _uid;

			_uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

			return _uid;
		}
	}

	private string _name;
	public string name {
		get { return _name; }
	}

	public Icon? icon {
		get { return null; }
	}

	private string uri;
	private string path;

	public PcEngineGame (string uri) throws Error {
		this.uri = uri;

		var file = File.new_for_uri (uri);
		path = file.get_path ();

		var name = file.get_basename ();
		name = /\.pce$/.replace (name, name.length, 0, "");
		name = name.split ("(")[0];
		_name = name.strip ();
	}

	public Runner get_runner () throws Error {
		var uid_string = uid.get_uid ();

		return new RetroRunner (MODULE_BASENAME, path, uid_string, SUPPORTS_SNAPSHOTTING);
	}
}

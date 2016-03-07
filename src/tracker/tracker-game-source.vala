// This file is part of GNOME Games. License: GPLv3

public class Games.TrackerGameSource : Object, GameSource {
	private const uint HANDLED_GAMES_PER_CYCLE = 5;

	private Tracker.Sparql.Connection connection { private set; get; }
	private TrackerQuery query;

	public TrackerGameSource (Tracker.Sparql.Connection connection, TrackerQuery query) {
		this.connection = connection;
		this.query = query;
	}

	public bool is_uri_valid (string uri) {
		return query.is_uri_valid (uri);
	}

	public Game game_for_uri (string uri) throws Error {
		return query.game_for_uri (uri);
	}

	public async void each_game (GameCallback game_callback) {
		yield each_game_for_query (game_callback, query);
	}

	public async void each_game_for_query (GameCallback game_callback, TrackerQuery query) {
		var sparql = query.get_query ();

		Tracker.Sparql.Cursor cursor;
		try {
			cursor = connection.query (sparql);
		}
		catch (Error e) {
			warning ("Error: %s\n", e.message);
			return;
		}

		bool is_cursor_valid = false;
		uint handled_games = 0;

		try {
			is_cursor_valid = cursor.next ();
		}
		catch (Error e) {
			is_cursor_valid = false;
			warning ("Error: %s\n", e.message);
		}
		while (is_cursor_valid) {
			if (query.is_cursor_valid (cursor))
				try {
					var game = query.game_for_cursor (cursor);
					game_callback (game);
					handled_games++;

					// Free the execution only once every HANDLED_GAMES_PER_CYCLE
					// games to speed up the execution by avoiding too many context
					// switching.
					if (handled_games >= HANDLED_GAMES_PER_CYCLE) {
						handled_games = 0;

						Idle.add (this.each_game_for_query.callback);
						yield;
					}
				}
				catch (TrackerError.FILE_NOT_FOUND e) {
					debug (e.message);
				}
				catch (Error e) {
					warning ("Error: %s\n", e.message);
				}

			try {
				is_cursor_valid = cursor.next ();
			}
			catch (Error e) {
				is_cursor_valid = false;
				warning ("Error: %s\n", e.message);
				continue;
			}
		}
	}
}

public errordomain TrackerError {
	FILE_NOT_FOUND,
}

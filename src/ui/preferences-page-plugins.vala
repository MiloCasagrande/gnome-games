// This file is part of GNOME Games. License: GPLv3

[GtkTemplate (ui = "/org/gnome/Games/ui/preferences-page-plugins.ui")]
private class Games.PreferencesPagePlugins: Gtk.Bin, PreferencesPage {
	public string name {
		get { return "plugins"; }
	}

	public string title {
		get { return _("Extensions"); }
	}

	public Gtk.Widget controls {
		get { return null; }
	}

	[GtkChild]
	private Gtk.ListBox list_box;

	construct {
		var register = PluginRegister.get_register ();
		register.foreach_plugin_registrar ((plugin_registrar) => {
			add_plugin_registrar (plugin_registrar);
		});
	}

	private void add_plugin_registrar (PluginRegistrar plugin_registrar) {
		var item = new PreferencesPagePluginsItem (plugin_registrar);
		var row = new Gtk.ListBoxRow ();
		row.add (item);
		list_box.add (row);

		item.show ();
		row.show ();
	}
}

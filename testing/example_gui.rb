#!/usr/bin/env ruby

require 'gtk2'

window = Gtk::Window.new
window.set_size_request(200, 100)
window.title = "GTK Entry"
window.signal_connect("destroy") {Gtk.main_quit}

vbox = Gtk::VBox.new(false, 0)
window.add(vbox)

entry = Gtk::Entry.new
entry.max_length = 50
entry.signal_connect("activate") {puts "Entry contents: #{entry.text}"}
entry.text = "Enter gmail email here"
entry.select_region(0, -1)
vbox.pack_start(entry, true, true, 0)

hbox = Gtk::HBox.new(false, 0)
vbox.add(hbox)

check = Gtk::CheckButton.new("Editable")
check.signal_connect("toggled") {|w| entry.editable = w.active?}
check.active = entry.editable?
hbox.pack_start(check, true, true, 0)

check = Gtk::CheckButton.new("Visible")
check.signal_connect("toggled") {|w| entry.visibility = w.active?}
check.active = entry.visibility?
hbox.pack_start(check, true, true, 0)

button = Gtk::Button.new("Submit")
button.signal_connect("clicked") do
puts entry.text
end
vbox.pack_start(button, true, true, 0)
button.can_default = true
button.grab_default

window.show_all
Gtk.main

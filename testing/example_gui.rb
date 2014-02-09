#!/usr/bin/env ruby

require 'gtk2'

window = Gtk::Window.new
window.set_size_request(300, 150)
window.title = "GTK Entry"
window.signal_connect("destroy") {Gtk.main_quit}

vbox = Gtk::VBox.new(false, 0)
window.add(vbox)

hbox = Gtk::HBox.new(false, 0)
vbox.add(hbox)

hbox1 = Gtk::HBox.new(false, 0)
vbox.add(hbox1)



email_label = Gtk::Label.new("Email: ")
hbox.pack_start(email_label, true, true, 0)

entry = Gtk::Entry.new
entry.max_length = 50
entry.signal_connect("activate") {puts "Entry contents: #{entry.text}"}
entry.text = "Enter gmail email here"
entry.select_region(0, -1)
hbox.pack_start(entry, true, true, 0)

pass_label = Gtk::Label.new("Password:")
hbox1.pack_start(pass_label, true, true, 0)

pass = Gtk::Entry.new
pass.max_length = 50
pass.signal_connect("activate") {puts "Entry contents: #{pass.text}"}
pass.text = "Give me your password!"
pass.visibility = false
#entry.select_region(0, -2)
hbox1.pack_start(pass,true,true, 0)


button = Gtk::Button.new("Submit")
button.signal_connect("clicked") do
puts entry.text
end
vbox.pack_start(button, true, true, 0)
button.can_default = true
button.grab_default

window.show_all
Gtk.main

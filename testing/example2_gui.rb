#!/usr/bin/env ruby
require 'gtk2'

window = Gtk::Window.new("Text Views")
window.resizable = true
window.border_width = 10
window.signal_connect('destroy') { Gtk.main_quit }
window.set_size_request(250, 150)

textview = Gtk::TextView.new
textview.buffer.text = "Your 1st Gtk::TextView widget!"

scrolled_win = Gtk::ScrolledWindow.new
scrolled_win.border_width = 5
scrolled_win.add(textview)
scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)

window.add(scrolled_win)
window.show_all
Gtk.main

textview.buffer.text = "Hope!"

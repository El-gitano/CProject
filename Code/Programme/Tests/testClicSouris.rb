require 'gtk2'

Gtk.init

window = Gtk::Window.new("Test clic")

window.add_events(Gdk::Event::BUTTON_PRESS_MASK)

window.signal_connect("button_press_event") do |widget, event|
  print event.button
end

window.show_all

Gtk.main

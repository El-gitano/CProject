require 'gtk2'

eventBox1 = Gtk::EventBox.new
eventBox2 = Gtk::EventBox.new

image = Gtk::Image.new("test.jpg")

eventBox1.add(image)
eventBox2.add(image)

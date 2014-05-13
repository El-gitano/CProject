#!/usr/bin/env ruby
require 'gtk2'

# Add three columns to the GtkTreeView. All three of the
# columns will be displayed as text, although one is a boolean
# value and another is an integer.
#
# NOTE:
#   sorting requires model parameter  <----                       ------ (sorting) --------
#   --------------------------------
def setup_tree_view(treeview, model)
  # Create a new GtkCellRendererText, add it to the tree
  # view column and append the column to the tree view.
  renderer = Gtk::CellRendererText.new
  renderer.foreground = "#ff0000"
  column   = Gtk::TreeViewColumn.new("Buy", renderer,  :text => BUY_IT)
  treeview.append_column(column)
  renderer = Gtk::CellRendererText.new
  column   = Gtk::TreeViewColumn.new("Count", renderer, :text => QUANTITY)
  column.sort_indicator=true
  column.sort_column_id = QUANTITY  # Note: PRODUCT maps to model column number
                                   #       and not to view column number!
  # column.clickable = true    # You'd need this only, if you didn't set column.sort_column_id

  column.signal_connect('clicked') do |w|
    w.sort_order = 
      w.sort_order == Gtk::SORT_ASCENDING ? Gtk::SORT_DESCENDING : Gtk::SORT_ASCENDING
  end
  treeview.append_column(column)
  renderer = Gtk::CellRendererText.new

  column   = Gtk::TreeViewColumn.new("Product", renderer, :text => PRODUCT)

  # Set up attributes and signals to sort this list by Product column 
  # ----------------------------------------------------------------------(sorting) -s- (1/2) --- 
  column.sort_indicator=true
  column.sort_column_id = PRODUCT  # Note: PRODUCT maps to model column number
                                   #       and not to view column number!
  # column.clickable = true    # You'd need this only, if you didn't set column.sort_column_id

  column.signal_connect('clicked') do |w|
    w.sort_order = 
      w.sort_order == Gtk::SORT_ASCENDING ? Gtk::SORT_DESCENDING : Gtk::SORT_ASCENDING
  end
  # ----------------------------------------------------------------------(sorting) -s- (1/2) ---  
  treeview.append_column(column)
end

window = Gtk::Window.new("Grocery List")
window.resizable = true
window.border_width = 10

window.signal_connect('destroy') { Gtk.main_quit }
window.set_size_request(250, 165)

class GroceryItem
  attr_accessor :buy, :quantity, :product
  def initialize(b, q, p); @buy, @quantity, @product = b, q, p; end
end
BUY_IT = 0; QUANTITY = 1; PRODUCT  = 2

list = Array.new
list[0] = GroceryItem.new(true,  1, "Paper Towels") 
list[1] = GroceryItem.new(true,  2, "Bread")
list[2] = GroceryItem.new(false, 1, "Butter")
list[3] = GroceryItem.new(true,  1, "Milk")
list[4] = GroceryItem.new(false, 3, "Chips")
list[5] = GroceryItem.new(true,  4, "Soda") 

# Create a new tree model with three columns, as Boolean,
# integer and string.
store = Gtk::ListStore.new(TrueClass, Integer, String)

treeview = Gtk::TreeView.new(store)

# -------------------------------------------------------------------- (sorting) -s- (2/2) ----
setup_tree_view(treeview, store)  # NOTE: sorting requires model arrgument too

# You could set also this Gtk::TreeSortable#set_sort_column_id here, however it is redundant 
# ------------------------------------------------------------------------------------------
# store.set_sort_column_id(sort_column_id=PRODUCT, order = Gtk::SORT_ASCENDING)  # redundant

# The following signal could have also been coded in the {{ setup_tree_view() }}
store.signal_connect('sort-column-changed') { puts "Sort order has bsen reversed " }
# -------------------------------------------------------------------- (sorting) -e- (2/2) ----

# Add all of the products to the GtkListStore.
list.each_with_index do |e, i|
    iter = store.append

    iter[BUY_IT]   = list[i].buy       # same as: >>> # store.set_value(iter, BUY_IT,   list[i].buy)
    iter[QUANTITY] = list[i].quantity  # same as: >>> # store.set_value(iter, QUANTITY, list[i].quantity)
    iter[PRODUCT]  = list[i].product   # same as: >>> # store.set_value(iter, PRODUCT,  list[i].product)
end

scrolled_win = Gtk::ScrolledWindow.new
scrolled_win.add(treeview)
scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)

window.add(scrolled_win)
window.show_all
Gtk.main

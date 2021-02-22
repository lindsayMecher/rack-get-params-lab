require 'pry'
class Application

#   Create a new class array called @@cart to hold any items in your cart.
# Create a new route called /cart to show the items in your cart.
# Create a new route called /add that takes in a GET param with the key item. This should check to see if that item is in @@items and add it to the cart if it is. Otherwise it should give an error.

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      binding.pry
      if @@cart.length == 0
        resp.write "Your cart is empty"
      else
        item_iteration(resp)
      end 
    elsif req.path.match(/add/)
      item_name = req.env["QUERY_STRING"].split("=")[1]
      # item_name = req.env["rack.request.query_hash"]["item"]
      if @@items.include? item_name
        @@cart << item_name
        resp.write "added #{item_name}"
        resp.status = 200
      else
        resp.write "We don't have that item" 
      end 
    else
      resp.write "Path Not Found"
      resp.status = 404
    end

    resp.finish
  end

  def item_iteration(resp)
    @@cart.each do |item|
      resp.write "#{item}\n"
    end
  end 

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end


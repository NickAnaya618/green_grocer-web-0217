require"pry"
require"pry-nav"

def consolidate_cart(cart)
  cart.each_with_object({}) do |hash, result|
    hash.each do |key, value_hash|
      if result[key]
        value_hash[:count] += 1
      else
        value_hash[:count] = 1
        result[key] = value_hash
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |product, attributes|
    attributes.each do |key, value|
      if attributes[:clearance] == true
        old_price = attributes[:price].to_f
        new_price = old_price * (80.to_f/100)
        attributes[:price] = new_price.round(2)
      end
      break
    end
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
end

require 'pry'

def consolidate_cart(cart)
  finalCart = {}
  cart.each do |hash|
    hash.each do |item, data|
      if !finalCart[item]
        finalCart[item] = {count: 1}
          data.each do |data, value|
            finalCart[item][data] = value
          end
      else
        finalCart[item][:count] = finalCart[item][:count] + 1
      end
    end
  end
  finalCart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        newItem = "#{coupon[:item]} W/COUPON"
        if cart[newItem]
          cart[newItem][:count] = cart[newItem][:count] + coupon[:num]
        else
          cart[newItem] = {
            count: coupon[:num],
            price: coupon[:cost] / coupon[:num],
            clearance: cart[coupon[:item]][:clearance]
          }
        end
        cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.keys.each do |key|
    if cart[key][:clearance]
      cart[key][:price] = (cart[key][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  apply_coupons(cart, coupons)
  apply_clearance(cart)
  finalCost = 0
  cart.keys.each do |key|
    finalCost += cart[key][:price] * cart[key][:count]
  end
  if finalCost > 100
    finalCost = (finalCost * 0.9).round(2)
  end
  finalCost
end

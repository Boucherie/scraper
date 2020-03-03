require 'nokogiri'
require 'httparty'
require 'byebug'


def scraper
  url = "https://www.knitpicks.com/yarn/view-all-yarns/c/300198?items=ALL"

  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)

  skeins = Array.new
  knit_product = parsed_page.css("div.category-item")    

#====================================
#pagination here for future projects
#====================================

  knit_product.each do |product|
    skein = {
      name: product.css("div.category-item-name").text.gsub(/\n/, "").strip,
      image_url: "https://www.knitpicks.com" + product.css("div.category-item-thumbnail>a").attribute('href').value.gsub(/\n/, "").strip,
      price_weight: product.css("div.category-item-pricing").text.gsub(/\n/, "").strip,
      weight: product.css("div.category-item-pricing").text.gsub(/\n/, "").strip.split.last(2).join(" "),
      price: product.css("div.category-item-pricing").text.gsub(/\n/, "").strip.split.slice(0..-1).join(" "),
      desc_fibre: product.css("div.category-item-yarndetails").text.gsub(/\n/, "").strip,

    }

    skeins << skein
    puts "Added #{skein[:name]}"
    puts " "
    
    byebug
  end
  
  
end

scraper
 



  # skein = doc.css("div.category-item")


  # How do you address the HTTParty deprecation where they no longer skip nil? Running through this exercise on a different site and came across this problem...

  # skein.each do |tile|
  #   name = tile.css("div#product-top-details h1[title]").text
  #   fibre = tile.css("").text
  #   weight = tile.css("").text
  #   gauge = tile.css("").text
  #   price = tile.css("").text
  #   description = tile.css("div#product-top-details div.short_description").text
  #   image_url = tile.css("").text
  #   brand=tile.css("").text

    # output[name.to_sym] = {
  #     fibre
  #     weight
  #     gauge
  #     price 
  #     description 
  #     image_url 
  #     brand

  #   }
  # end

  # output

# end


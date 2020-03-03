require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'



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
    
    # byebug
  end

  CSV.open('tricoter.csv', 'w') do |csv|
    csv << ["name", "image_url", "weight"]
    skeins.each do |skein|
    csv << [
      skein[:name],
      skein[:image_url],
      skein[:price]
    ]
    end
  end
end
scraper
 




# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  name               :string
#  image              :string
#  description        :text
#  price              :decimal(, )
#  quantity           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Product < ApplicationRecord
  has_many :sales_order
  has_attached_file :image, styles: { small: "64x64", med: "300x300", large: "522x620" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ 

  def self.get_info
    items = []
    stores = Store.all
    stores.each { |store|
      if ((RestClient.get("#{store.connecting_link}#{store.list_products}")).code >= 200 && (RestClient.get("#{store.connecting_link}#{store.list_products}")).code < 300) && store.buy_product == "Activo"
        inf = JSON.parse RestClient.get("#{store.connecting_link}#{store.list_products}") 
        inf.each { |item|
          items << item
        }
      else
      end
    } 
    return items  
  end

  def modify_image(hash)
    hash.map do |product|
      {
      :store => "HACKS-ELECTRONICS.CA",
      :category => "Electronicos",
      :id => product.id,
      :name => product.name, 
      :image => "http://192.168.34.129:3000#{product.image}",
      :description => product.description,
      :price => product.price,
      :quantity => product.quantity,
      :path => "http://192.168.34.129:3000/api/v1/products/"
      }     #product.image = "#{Store.find_by(name: "HACKS-ELECTRONICS.CA").connecting_link}#{product.image}"
    end  
  end

  ###### Para pruebas 
  # def self.get_info   ### metodo para parsear 
  #   items = []
  #   inf = JSON.parse RestClient.get("http://192.168.34.128:3000/api/v1/stores/1/products") ### cambiar liks
  #   inf.each { |item|
  #     items << item
  #   }
  # end
end

# == Schema Information
#
# Table name: pages
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  slug                :string(255)
#  local_menu          :boolean
#  local_menu_position :integer
#  body                :text
#  metadesc            :string(255)
#  metakeywords        :string(255)
#  seo_title           :string(255)
#  print_link          :boolean          default(FALSE)
#  tenant_id           :integer
#  created_at          :datetime
#  updated_at          :datetime
#  hic_app             :string(255)
#

class Page < ActiveRecord::Base

  include Tenantable
#uploaders
#friendly_id
#instances
#attrs
#associations
  has_many :page_blocks
  has_many :blocks, through: :page_blocks
  has_many :slider_items
#scopes
  default_scope { with_tenant_constraint.where(hic_app: nil) }
#validations
  validates :title, presence: true, uniqueness: { scope: :tenant_id }
  validates :slug, presence: true, slug: true
  validates :slug, change: false, on: :update
#callbacks
  before_validation :parameterize_slug, on: :create
#other_logic


  # has_many :blocks, through: :page_blocks

  # has_many :page_blocks, dependent: :destroy

  # has_many :visible_blocks, through: :page_blocks,
  #          class_name: "Block",
  #          source: :block,
  #          order: "page_blocks.position ASC",
  #          conditions: ['page_blocks.visible = ?', true]

  # has_many :slider_items
  # has_one :global_nav_item

  # scope :global_nav, find_all_by_slug(["setup","for_dealers", "catalog", "others", "contacts"])
  # scope :local_nav, where(local_menu: true).order(:local_menu_position)
=begin
  def visible_blocks
    # need to refactor code string below
    Block.find_all_by_id(self.page_blocks.where(visible: true).order("position ASC").collect(&:block_id))
  end
=end

######################## common logic ########################
  def to_param
    slug
  end

  def self.find(input)
    input.to_i == 0 ? find_by(slug: input) : super
  end

  def has_slider?
    pages_with_slider = ["main"]
    pages_with_slider.include?(slug)
  end

  def self.main
    find_by(slug: "main")
  end

  def main?
    self.slug == "main"
  end

  def has_block_informer?
    !(slider_items.empty? || has_slider?)
  end

  def block_informer
    slider_items.first if has_block_informer?
  end

  private
    #callback_methods
    def parameterize_slug
      self.slug = self.slug.parameterize
    end
    #validation_methods
end

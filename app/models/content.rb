# encoding: utf-8
# == Schema Information
#
# Table name: contents
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  block_id      :integer
#  title_image   :string(255)
#  teaser_body   :text
#  undercut_body :text
#  position      :integer
#  visible       :boolean          default(FALSE)
#  slug          :string(255)
#  metadesc      :string(255)
#  metakeywords  :string(255)
#  ancestry      :string(255)
#  start_date    :date
#  finish_date   :date
#  seo_title     :string(255)
#  tenant_id     :integer
#  created_at    :datetime
#  updated_at    :datetime
#  location      :string(255)
#  catalog_image :string(255)
#

class Content < ActiveRecord::Base

  include Tenantable
#uploaders
  mount_uploader :title_image, SliderImageUploader
  mount_uploader :catalog_image, MainImageUploader
#friendly_id
#instances
#attrs
  attr_writer :full_body
#associations
  belongs_to :block
  belongs_to :tenant
  has_many :content_images
  has_ancestry
#scopes
#validations
  validates :title, presence: true
#callbacks
  before_create :set_position
  before_validation :set_seolink
  #before_save :split_body, :html_fixing

  skip_callback :commit, :after, :remove_catalog_image!
  skip_callback :commit, :after, :remove_title_image!
  skip_callback :save, :after, :remove_previously_stored_title_image
  skip_callback :save, :after, :remove_previously_stored_catalog_image
#other_logic


  def self.sort(contents)
    contents.each_with_index{|id, idx| Content.find(id).update(position: idx)}
  end


  def self.date_visible
    where("start_date <= ?", Time.now).where("finish_date > ?", Time.now).where(visible: true).order("position")
  end

  def html_fixing
    self.teaser_body = Nokogiri::HTML::DocumentFragment.parse(teaser_body).to_html
    self.undercut_body = Nokogiri::HTML::DocumentFragment.parse(undercut_body).to_html
  end

  def full_body
    # strip_tags работает, так как прописан в initializers/class_rewriter.rb

    if undercut_body && !ActionController::Base.helpers.strip_tags(undercut_body).blank?
      @full_body || "#{teaser_body if teaser_body}<hiconix_cut>Разрыв страницы</hiconix_cut>#{undercut_body}"
    elsif teaser_body
      @full_body || teaser_body
    end
  end

  def set_seolink
    if self.title?
      name = Russian.translit(self.title)
      self.slug = name.gsub(' ','-').gsub(/[^\x00-\x7F]+/, '').gsub(/[^\w_ \-]+/i,   '').gsub(/[ \-]+/i,      '-').gsub(/^\-|\-$/i,      '').downcase
    end
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end

# below, up to private zone - territory of SEARCH!!

  def url
    if self.block.presence
      "http://hiconix.ru/contents/#{self.id}-#{self.slug}"
    else
      "#{tenant.try(:current_domain)}/articles/#{self.id}-#{self.slug}"
    end
  end

  def html_to_text(html)
    Nokogiri::HTML(html).text
  end

private

  #callback_methods
  def set_position
    self.position = (block.contents.by_position.try(:last).try(:position) || 0) + 1
  end

  def split_body
    if @full_body
      body_array = @full_body.split(/<hiconix_cut>.*<\/hiconix_cut>/)
      unless body_array.empty?
        self.teaser_body = body_array[0] unless ActionController::Base.helpers.strip_tags(body_array[0]).blank?
        undercut_body_array = body_array[1..body_array.length].join
      end
      if undercut_body_array
        self.undercut_body = undercut_body_array unless ActionController::Base.helpers.strip_tags(undercut_body_array).blank?

      end
    end
  end
#validation_methods
end
